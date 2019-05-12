import React, { Component } from "react";
import DataList from "./datalist.js";
import ActionsList from "./actionslist.js";
import DecisionView from "./decisionview.js";
import PaymentView from "./paymentview.js";
import HistoryView from "./historyview.js";
import DataOverview from "./dataoverview.js";
import { MessageWait, ButtonExampleLoading } from "./message.js";
import { zip } from "../store.js";

class Case extends Component {
  constructor(props) {
    super(props);
    this.update = this.update.bind(this);
    this.editData = this.editData.bind(this);
    this.dontEditData = this.dontEditData.bind(this);
    this.updateInput = this.updateInput.bind(this);
    this.handleAppeal = this.handleAppeal.bind(this);
  }

  state = {
    data: null,
    datalist: [],
    actions: [],
    isLoading: true,
    loadstage: 0
  };

  componentDidMount() {
    this.update();
  }

  componentWillReceiveProps(props) {
    this.update();
  }

  openZip() {
    zip(this.props.case.id);
    this.setState({
      loadstage: 1
    });
    setTimeout(
      () =>
        this.setState({
          loadstage: 2
        }),
      2400
    );
  }

  hashData() {
    setTimeout(
      () =>
        this.setState({
          loadstage: 3
        }),
      4400
    );
  }

  caseStatusText(status) {
    switch (parseInt(status)) {
      case 0:
        return "Aktiv";
      case 1:
        return "Under klage";
      case 2:
        return "Hos ankestyrelsen";
      default:
        return "Fejl";
    }
  }

  async update() {
    if (this.props.case.id) {
      await this.setState({ isLoading: true });
      const add = await this.props.contractContext.contract.methods
        .addressFromCase(this.props.case.id)
        .call();
      await this.props.contractContext.caseData(this.props.case).then(res => {
        var actions =
          this.props.contractContext.role === 0
            ? res.actions.filter(a => a.type === "2")
            : res.actions;
        this.setState({
          data: res.data,
          datalist: res.datalist,
          actions: actions,
          isLoading: false,
          address: add,
          marked: res.marked
        });
      });
    }
  }

  async editData(d) {
    this.state.actions.push(d);
    await this.setState({
      actions: this.state.actions
    });
  }

  async dontEditData(d) {
    await this.setState({
      actions: this.state.actions.filter(a => a !== d)
    });
  }

  updateInput(e) {
    this.value = e.target.value;
  }

  dataList() {
    return (
      <DataList
        contractContext={this.props.contractContext}
        data={this.state.data}
        editData={this.editData}
        dontEditData={this.dontEditData}
        case={this.props.case}
      />
    );
  }

  async handleAppeal() {
    if (this.state.marked) {
      await this.props.contractContext.redo(this.props.case.id);
    } else {
      await this.props.contractContext.ratify(this.props.case.id);
    }
  }

  appealsboardInterface() {
    if (this.state.loadstage < 1) {
      return (
        <div className="f6 bg-near-white ba pa3 black-60 helvetica ma2">
          {MessageWait("Ny sag fra Syddjurs Kommne", "Modtag sagens filer")}
          <div className="dim">
            {ButtonExampleLoading("Åben filer", () => this.openZip())}
          </div>
        </div>
      );
    }
    if (this.state.loadstage < 2) {
      return (
        <div className="f6 bg-near-white ba dim pa3 black-60 helvetica ma2">
          {MessageWait("Ny sag fra Syddjurs Kommne", "Åbner filer")}
        </div>
      );
    }
    if (this.state.loadstage < 3) {
      this.hashData();
      return (
        <div className="f6 bg-near-white ba dim pa3 black-60 helvetica ma2">
          {MessageWait("Et øjeblik", "Beregner hashes af den modtagede data")}
        </div>
      );
    }
    return (
      <div>
        <div className="w-100 flex justify-center">
          {this.dataList()}
          <div className="w-50 flex justify-center items-center">
            {this.props.case.status === "3" ? (
              <div>
                <button
                  className="helvetica f6 br1 ba bg-white fr mr3"
                  onClick={() => this.handleAppeal()}
                >
                  {this.state.marked ? "Hjemvis" : "Stadfæst"}
                </button>
              </div>
            ) : (
              <div className="w-50" />
            )}
          </div>
        </div>
        <HistoryView
          id={this.props.case.id}
          contractContext={this.props.contractContext}
        />
        <DataOverview
          contractContext={this.props.contractContext}
          datas={this.state.datalist}
        />
      </div>
    );
  }

  sbhInterface(data) {
    return (
      <div>
        <div className="w-100 flex justify-center helvetica">
          {this.dataList()}
          {this.props.case.status !== "2" ? (
            <ActionsList
              contractContext={this.props.contractContext}
              actions={this.state.actions}
              case={this.props.case}
            />
          ) : (
            <div className="w-50" />
          )}
        </div>
        <PaymentView
          case={this.props.case}
          contractContext={this.props.contractContext}
        />
        <HistoryView
          id={this.props.case.id}
          contractContext={this.props.contractContext}
        />

      </div>
    );
  }

  citizenInterface(data) {
    return (
      <div>
        <div className="w-100 flex justify-center">
          {this.props.case.status === "0" && this.state.actions.length > 0 ? (
            <ActionsList
              contractContext={this.props.contractContext}
              actions={this.state.actions}
              data={this.state.history}
              case={this.props.case}
            />
          ) : (
            <div className="w-50" />
          )}
          <div className="w-50" />
        </div>
        <PaymentView
          case={this.props.case}
          contractContext={this.props.contractContext}
        />
        <DecisionView
          case={this.props.case}
          contractContext={this.props.contractContext}
        />
      </div>
    );
  }

  getInterface() {
    if (this.props.contractContext.role === 0) return this.citizenInterface();
    if (this.props.contractContext.role === 1) return this.sbhInterface();
    if (this.props.contractContext.role === 2) return this.appealsboardInterface();
    return null;
  }

  render() {
    return (
      <div className="w-100 flex flex-column items-left justify-around ph5">
        {this.state.isLoading ? (
          <h2 className="f4 helvetica tc pa2 mt2 mr2">Loader...</h2>
        ) : (
          <div>
            <h2 className="f4 helvetica tl pa2 mt2 mr2">
              <span className="b">Sagsnummer: </span>
              {this.props.case.id}
            </h2>
            <h2 className="f4 helvetica tl pa2 mt2 mr2">
              <span className="b">Addresse: </span>
              {this.state.address}
            </h2>
            <h2 className="f4 helvetica tl pa2 mt2 mr2 mb4">
              <span className="b">Status: </span>
              {this.caseStatusText(this.props.case.status)}
            </h2>
            {this.getInterface()}
          </div>
        )}
      </div>
    );
  }
}

export default Case;

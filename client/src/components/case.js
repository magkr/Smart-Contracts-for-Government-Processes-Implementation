import React, { Component } from "react";
import DataList from "./datalist.js";
import ActionsList from "./actionslist.js";
import ResolutionView from "./resolutionview.js";
import HistoryView from "./historyview.js";

class Case extends Component {
  constructor(props) {
    super(props);
    this.update = this.update.bind(this);
    this.editData = this.editData.bind(this);
    this.dontEditData = this.dontEditData.bind(this);
    this.updateInput = this.updateInput.bind(this);
    this.handleComplaint = this.handleComplaint.bind(this);
  }

  state = {
    data: null,
    actions: [],
    isLoading: true,
    history: []
  };

  componentDidMount() {
    this.update();
  }

  componentWillReceiveProps(props) {
    this.setState({
      history: []
    })
    this.update();
  }

  caseStatusText(status) {
    switch (parseInt(status)) {
      case 0:
        return "Aktiv"
      case 1:
        return "Under klage";
      case 2:
        return "Klar til udbetaling";
      case 3:
        return "Hos ankestyrelsen";
      default:
        return "Fejl";
    }
  }


  async update() {
    if (this.props.case.id) {

      await this.setState({ isLoading: true });
      const add = await this.props.contractContext.contract.methods.addressFromCase(this.props.case.id).call();
      await this.props.contractContext.caseData(this.props.case).then(res => {
        var actions = (this.props.contractContext.role === 0) ? res.actions.filter(a => a.type === "2") : res.actions;
        this.setState({
            data: res.data,
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
    )
  }

  handleComplaint(){
    if(this.state.marked) {
      this.props.contractContext.homesend(this.props.case.id);
    }
    else {
      this.props.contractContext.stadfast(this.props.case.id);
    }
    this.setState({ marked: false })
  }

  councilInterface(data) {
    return (
      <div>
        <div className="w-100 flex justify-center">
          {this.dataList()}
          <div className="w-50 flex justify-center items-center">
            {this.props.case.status === "3"
              ?
              (<div>
              <button className="helvetica f6 br1 ba bg-white fr mr3" onClick={() => this.handleComplaint()}>
                {this.state.marked ? "Hjemvis" : "Stadfæst"}
              </button>
            </div>)
              : null
            }

          </div>
        </div>
        <HistoryView
            id={this.props.case.id}
            contractContext={this.props.contractContext}
          />
      </div>
    );
  }

  sbhInterface(data) {
    return (
      <div>
        <div className="w-100 flex justify-center">
          {this.dataList()}
          {this.props.case.status === "3" ? (
            <div>
              <input
                className="helvetica w-80"
                type="text"
                onChange={this.updateInput}
              />
            <input
                className="helvetica w-20 f6 ml3 br1 ba bg-white"
                onClick={() => this.props.contractContext.handlePayment(this.props.case.id, this.value)}
                type="submit"
              />
            </div>
          ) : (
            <ActionsList
              contractContext={this.props.contractContext}
              actions={this.state.actions}
              actionss={this.state.actionss}
              data={this.state.history}
              case={this.props.case}
            />
        )}
      </div>
      <HistoryView
          cid={this.props.case.id}
          history={this.state.history}
          contractContext={this.props.contractContext}
        />
    </div>
    );
  }

  citizenInterface(data) {
    return (
      <div>
        <div className="w-100 flex justify-center">
          {this.dataList()}
          <ActionsList
            contractContext={this.props.contractContext}
            actions={this.state.actions}
            data={this.state.history}
            case={this.props.case}
          />
        </div>
        <ResolutionView
          id={this.props.case.id}
          contractContext={this.props.contractContext}
        />
      </div>
    );
  }

  getInterface() {
    if (this.props.contractContext.role === 0 ) return this.citizenInterface();
    if (this.props.contractContext.role === 1 ) return this.sbhInterface();
    if (this.props.contractContext.role === 2 ) return this.councilInterface();
    return null;
  }

  render() {
    return (
      <div className="w-100 flex flex-column items-left justify-around ph5">
        {this.state.isLoading ? (
          <h2 className="f4 helvetica tc pa2 mt2 mr2">Loading...</h2>
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
            <h2 className="f4 helvetica tl pa2 mt2 mr2">
              <span className="b">Status: </span>
              {this.caseStatusText(this.props.case.status)}
            </h2>
            { this.getInterface() }
          </div>
        )}
      </div>
    );
  }
}

export default Case;

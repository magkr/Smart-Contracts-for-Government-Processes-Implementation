import React, { Component } from "react";
import DataList from "./datalist.js";
import ActionsList from "./actionslist.js";
import ResolutionView from "./resolutionview.js";
import HistoryView from "./historyview.js";
import "../css/reset.css";
import "../css/tachyons.min.css";

class Case extends Component {
  constructor(props) {
    super(props);
    this.update = this.update.bind(this);
    this.editData = this.editData.bind(this);
    this.dontEditData = this.dontEditData.bind(this);
    this.updateInput = this.updateInput.bind(this);
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
        return "Afgjort"
      case 3:
        return "Klar til udbetaling";
      case 4:
        return "Forældet";
      default:
        return "Fejl";
    }
  }


  async update() {
    if (this.props.case) {
      console.log(this.props.case);
      await this.setState({ isLoading: true });
      const add = await this.props.contractContext.contract.methods.addressFromCase(this.props.case.id).call();
      await this.props.contractContext.caseData(this.props.case).then(res => {
        this.setState({
            data: res.data,
            actions: res.actions,
            isLoading: false,
            address: add
          });
      });
      if (
        this.props.contractContext.web3 &&
        this.props.contractContext.contract
      ) {
        this.props.contractContext.contract.events
          .NewData(
            {
              filter: {
                caseID: this.props.id
              }, // Using an array means OR: e.g. 20 or 23
              fromBlock: 0,
              toBlock: "latest"
            },
            async function(error, result) {
              if (!error) {
                //console.log(result);
                // event arguments cointained in result.args object
                // new data have arrived. it is good idea to udpate data & UI
              } else {
                // log error here
                console.log(error);
              }
            }
          )
          .on("data", async e => {
            console.log(e);
            await this.setState({
              history: [e.returnValues, ...this.state.history]
            });
          })
          .on("changed", e => {
            // remove event from local database ???????
          })
          .on("error", e => {
            console.log(e);
          });
      }
    }
    console.log(this.state.data);
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

  councilInterface(data) {
    return (
      <div>
        <div className="w-100 flex justify-center">
          {this.dataList()}
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
          {this.props.case.status === "3" ? ( // MAGNUS HJÆLP (opdater og prettify)
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
              data={this.state.history}
              case={this.props.case}
            />
        )}
      </div>
      <HistoryView
          id={this.props.case.id}
          history={this.state.history}
          contractContext={this.props.contractContext}
        />
    </div>
    );
  }

  citizenInterface(data) {
    return (
      <ResolutionView
        id={this.props.case.id}
        contractContext={this.props.contractContext}
      />
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
              <span className="b">Address: </span>
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

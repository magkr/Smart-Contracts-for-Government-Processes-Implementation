import React, { Component } from "react";
import { saveData } from "../store.js";
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
    this.submitData = this.submitData.bind(this);
    this.handlePayment = this.handlePayment.bind(this);
    this.updateInput = this.updateInput.bind(this);
    this.readData = this.readData.bind(this);
  }

  state = {
    data: null,
    actions: [],
    isLoading: true
  };

  componentDidMount() {
    this.update();
  }

  componentWillReceiveProps(props) {
    this.update();
  }

  async update() {
    await this.setState({ isLoading: true });
    await this.readData(this.props.case).then(res => {
      this.setState({
          data: res.data,
          actions: res.actions,
          isLoading: false
        });
    });
  }


  async submitData(action, value) {
    let hash = this.props.contractContext.web3.utils.sha3(value);
    console.log(hash);
    await this.props.contractContext.contract.methods
      .fillData(action, this.props.case.id, hash)
      .send({ from: this.props.contractContext.accounts[0] })
      .then(async transaction => {
        console.log(transaction);
        const bcData = transaction.events.NewData.returnValues
        await saveData(bcData.action, bcData.caseID, value, bcData.dataHash, bcData.location)
          .catch(error => {
            console.log(`ERROR: save data to database failed`);
          });
      })
      .catch(error => {
        console.log("ERROR: submit data to blockchain failed");
        return error;
      });
    await this.update();
  }

  async readData(c) {
    const actions = [];
    const phaseStruct = {};
    await this.props.contractContext.contract.methods
      .getCase(c.id)
      .call()
      .then(data => {
        data["phases"].forEach((phase, idx) => {
          if (!phaseStruct[phase]) phaseStruct[phase] = [];
          phaseStruct[phase].push({
            id: data["ids"][idx],
            title: data["titles"][idx],
            status: data["statuss"][idx],
            ready: data["isReady"][idx],
            phase: data["phases"][idx]
          });
          if (data["isReady"][idx]) {
            actions.push(data["titles"][idx]);
          }
        });
      });
    return { data: phaseStruct, actions: actions };
  }

  async editData(d) {
    this.state.actions.push(d.title);
    this.setState({
      actions: this.state.actions
    });
  }

  handlePayment(e) {
    let money = this.props.contractContext.web3.utils.toWei(
      this.value,
      "ether"
    );
    console.log(money);
    this.props.contractContext.contract.methods
      ._sendEther(this.props.case.id)
      .send({ from: this.props.contractContext.accounts[0], value: money });
  }

  updateInput(e) {
    this.value = e.target.value;
  }

  adminInterface(data) {
    return (
      <div className="w-100 flex justify-center">
        <DataList
          contractContext={this.props.contractContext}
          data={this.state.data}
          editData={this.editData}
          update={this.update}
        />
        {this.state.status === "3" ? (
          <div>
            <input
              className="helvetica w-80"
              type="text"
              onChange={this.updateInput}
            />
            <button
              className="helvetica w-20 f6 ml3 br1 ba bg-white"
              onClick={this.handlePayment}
            />
          </div>
        ) : (
          <ActionsList
            contractContext={this.props.contractContext}
            actions={this.state.actions}
            case={this.props.case.id}
            submitData={this.submitData}
          />
        )}
      </div>
    );
  }

  render() {
    // var balance = 0;
    // this.props.contractContext.web3.eth.getBalance(
    //   this.state.addr
    // ).then(res => balance = res);
    return (
      <div className="w-100 flex flex-column items-left justify-around ph5">
        {this.state.isLoading ? (
          <h2 className="f4 helvetica tc pa2 mt2 mr2">Loading...</h2>
        ) : (
          <div>
            <h2 className="f4 helvetica tl pa2 mt2 mr2">
              <span className="b">Case ID: </span>
              {this.props.case.id}
            </h2>
            <h2 className="f4 helvetica tl pa2 mt2 mr2">
              <span className="b">Address: </span>
              {this.props.contractContext.accounts[0]}
            </h2>
            <h2 className="f4 helvetica tl pa2 mt2 mr2">
              <span className="b">Status: </span>
              {this.props.case.status}
            </h2>
            { this.state.data !== null && this.props.contractContext.role === 1
              ? this.adminInterface()
              : null}
            { this.props.contractContext.role === 0 ?
              <ResolutionView
                id={this.props.case.id}
                contractContext={this.props.contractContext}
              />
            :
            <HistoryView
                id={this.props.case.id}
                contractContext={this.props.contractContext}
              />
             }
          </div>
        )}
      </div>
    );
  }
}

export default Case;

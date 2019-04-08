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
    this.handlePayment = this.handlePayment.bind(this);
    this.updateInput = this.updateInput.bind(this);
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
    await this.props.contractContext.caseData(this.props.case).then(res => {
      this.setState({
          data: res.data,
          actions: res.actions,
          isLoading: false
        });
    });
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
      .sendEther(this.props.case.id)
      .send({ from: this.props.contractContext.accounts[0], value: money });
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
                onClick={this.handlePayment}
                type="submit"
              />
            </div>
          ) : (
            <ActionsList
              contractContext={this.props.contractContext}
              actions={this.state.actions}
              case={this.props.case}
            />
        )}
      </div>
      <HistoryView
          id={this.props.case.id}
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
            { this.getInterface() }
          </div>
        )}
      </div>
    );
  }
}

export default Case;

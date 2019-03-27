import "../css/reset.css";
import "../css/tachyons.min.css";
import React, { Component } from "react";

export default class Action extends Component {
  state = {
    value: ""
  };

  updateValue = e => {
    this.setState({ value: e.target.value });
  };

  fillData = async () => {
    await this.props.contractContext.contract.methods
      .fillData(
        this.props.action,
        this.props.caseID,
        this.props.contractContext.web3.utils.asciiToHex(this.state.value),
        window.sessionStorage.length + 1
      )
      .send({ from: this.props.contractContext.accounts[0] });
    window.sessionStorage[window.sessionStorage.length + 1] = this.state.value;
    await this.props.update();
    console.log(this.props.contractContext.store);
  };

  render() {
    const utils = this.props.contractContext.web3.utils;
    return (
      <div className="w-100 bg-near-white pa2 mv2">
        <div className="flex items-end helvetica f5">
          {utils.hexToAscii(this.props.action)}
        </div>
        <div className="helvetica flex justify-around mt3">
          <input
            className="helvetica w-80"
            type="text"
            onChange={this.updateValue}
          />
          <button
            className="helvetica w-20 f6 ml3 br1 ba bg-white"
            onClick={this.fillData}
          >
            Submit
          </button>
        </div>
      </div>
    );
  }
}

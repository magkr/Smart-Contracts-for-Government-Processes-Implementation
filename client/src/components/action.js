import '../css/reset.css';
import '../css/tachyons.min.css';
import React, { Component } from "react";

export default class Action extends Component {
  state = {
    hash: ""
  }

  updateHash = (e) => {
    this.setState({ hash: e.target.value })
  }

  fillData = async () => {
    console.log(this.props.action);
    await this.props.contractContext.contract.methods.fillData(this.props.action, this.props.caseID, this.state.hash).send({ from: this.props.contractContext.accounts[0] });
    await this.props.getActions();
  }

  render(){
    const utils = this.props.contractContext.web3.utils;
    return (
      <div className="w-100 bg-near-white pa2 mv2">
        <div className="flex items-end helvetica f5">{utils.hexToAscii(this.props.action)}</div>
        <div className="helvetica flex justify-around mt3">
          <input className="helvetica w-80" type="text" onChange={this.updateHash}/>
          <button className="helvetica w-20 f6 ml3 br1 ba bg-white" onClick={this.fillData}>Submit</button>
        </div>
      </div>
    )
  }
}

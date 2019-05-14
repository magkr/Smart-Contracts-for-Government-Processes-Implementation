import React, { Component } from "react";
import { getData, zip } from "../utils/store.js";

export default class Action extends Component {
  constructor(props) {
    super(props);
    this.utils = this.props.contractContext.web3.utils;
    this.state = {
      value: ""
    };
    this.onClick = this.onClick.bind(this);
    this.submit = this.submit.bind(this);
    this.ratify = this.ratify.bind(this);
  }

  isAppealedDecision() {
    return this.props.action.type === "1" && this.props.action.status === "4";
  }

  noData() {
    return this.props.action.id < this.utils.asciiToHex(1);
  }

  componentDidMount = async () => {
    if (this.noData()) return;
    var response = await getData(
      this.props.action.caseID,
      this.props.action.id
    );
    if (response) {
      await this.setState({
        prevValue: response.value,
        value: response.value
      });
      this.props.addValueToSubmit(this.props.action.title, response.value);
    }
  };

  async update(e) {
    var val = e.target.value;
    await this.setState({
      value: val
    });
    this.props.addValueToSubmit(this.props.action.title, val);
  }

  isUnchanged() {
    return this.state.value === this.state.prevValue && this.state.value !== "";
  }

  buttonText() {
    if (this.isAppealedDecision())
      return this.isUnchanged() ? "Stadfæst" : "Ændre afgørelse";
    else return this.isUnchanged() ? "Behold" : "Indsend";
  }

  async sendZip() {
    alert(`Sender data for sag ${this.props.action.caseID} til Ankestyrelsen`);
    zip(this.props.action.caseID);
  }

  async onClick() {
    if (this.isAppealedDecision() && this.isUnchanged()) this.ratify();
    else this.submit();
  }

  async ratify() {
    await this.submit().then(() => this.sendZip());
  }

  async submit() {
    await this.props.contractContext.submitData(
      this.props.action.title,
      this.props.action.caseID,
      this.state.value
    );
  }

  render() {
    return (
      <div className="w-100 bg-near-white pa2 mv2">
        <div className="flex items-end helvetica f5">
          {this.utils.hexToUtf8(this.props.action.title)}
        </div>
        <div className="helvetica flex justify-around mt3">
          <input
            className="helvetica w-80"
            type="text"
            value={this.state.value}
            onChange={e => this.update(e)}
          />
          <button
            className="helvetica w-20 f6 ml3 br1 ba bg-white"
            onClick={() => this.onClick()}
          >
            {this.buttonText()}
          </button>
        </div>
      </div>
    );
  }
}

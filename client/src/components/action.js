import React, { Component } from "react";
import { getData, zip } from "../store.js";

export default class Action extends Component {
  constructor(props) {
    super(props);
    this.utils = this.props.contractContext.web3.utils;
    this.state = {
      value: ""
    };
    this.onClick = this.onClick.bind(this);
  }

  erKlageAfgørelse() {
    return (
      this.props.action.type === "1" &&
      this.props.action.status === this.utils.asciiToHex("complained")
    );
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

  buttonText() {
    var unchangedValue =
      this.state.value === this.state.prevValue && this.state.value !== "";

    if (this.erKlageAfgørelse())
      return unchangedValue ? "Stadfæst" : "Ændre afgørelse";
    else return unchangedValue ? "Behold" : "Indsend";
  }

  async sendZip() {
    alert(`Sender data for case ${this.props.action.caseID} til Ankestyrelsen`);
    setTimeout(() => zip(this.props.action.caseID), 3000);
  }

  async onClick() {
    await this.props.contractContext
      .submitData(
        this.props.action.title,
        this.props.action.caseID,
        this.state.value
      )
      .then(() => {
        if (this.erKlageAfgørelse()) this.sendZip();
      });
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

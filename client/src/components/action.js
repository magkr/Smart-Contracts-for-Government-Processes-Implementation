import React, { Component } from "react";
import { getData } from "../store.js";


export default class Action extends Component {
  constructor(props) {
    super(props);
    this.state = {
      value: ""
    };
  }

  componentDidMount = async () =>  {
    if (this.props.action.id < this.props.contractContext.web3.utils.asciiToHex(1)) return;
    var response = await getData(this.props.action.id);
    await this.setState({
      prevValue: response.data.value,
      value: response.data.value
    });
    this.props.addValueToSubmit(this.props.action.title, response.data.value);
  }

  async update(e) {
    var val = e.target.value
    await this.setState({
      value: val
    });
    this.props.addValueToSubmit(this.props.action.title, val);
  }

  buttonText() {
    if (this.props.action.type === "1" && this.props.action.status === this.props.contractContext.web3.utils.asciiToHex("complained")) {
      return this.state.value === this.state.prevValue && this.state.value !== "" ? "Stadfæst" : "Ændre afgørelse";
    } else {
      return this.state.value === this.state.prevValue && this.state.value !== "" ? "Behold" : "Indsend";
    }
  }

  render() {
    const utils = this.props.contractContext.web3.utils;
    return (
      <div className="w-100 bg-near-white pa2 mv2">
        <div className="flex items-end helvetica f5">
          {utils.hexToUtf8(this.props.action.title)}
        </div>
        <div className="helvetica flex justify-around mt3">
          <input
            className="helvetica w-80"
            type="text"
            value={this.state.value}
            onChange={(e) => this.update(e)}
          />
          <button
            className="helvetica w-20 f6 ml3 br1 ba bg-white"
            onClick={() => this.props.submitData(this.props.action.title, this.state.value)}
          >
            {this.buttonText()}
          </button>
        </div>
      </div>
    );
  }
}

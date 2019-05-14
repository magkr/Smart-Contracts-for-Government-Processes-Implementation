import React, { Component } from "react";
import { getData } from "../utils/store.js";

export default class Row extends Component {
  constructor(props) {
    super(props);
    this.state = {
      value: "",
      hash: ""
    };
  }

  componentDidMount(prevProps) {
    this.update();
  }

  componentDidUpdate(prevProps) {
    if (this.props.location !== prevProps.location) {
      this.update();
    }
  }

  async update() {
    var response = await getData(this.props.caseid, this.props.location);
    if (response) {
      await this.setState({
        value: response.value,
        hash: this.props.contractContext.web3.utils.sha3(response.value)
      });
    } else {
      await this.setState({
        value: "not found in database",
        hash: "-"
      });
    }
  }

  color() {
    return this.state.hash !== this.props.hash ? "bg-washed-red" : "bg-washed-green";
  }

  render() {
    return (
      <div className="flex word-wrap w-100">
        <div className="pa1 w-15 bg-near-white mv1">
          {this.props.contractContext.web3.utils.hexToUtf8(this.props.title)}
        </div>
        <div className="pa1 w-10 bg-near-white ma1">{this.props.location}</div>
        <div className="pa1 w-25 bg-near-white mv1">{this.props.hash}</div>
        <div className={"pa1 w-25 ma1 " + this.color()}>{this.state.hash}</div>
        <div className="pa1 w-25 bg-near-white mv1">{this.state.value}</div>
      </div>
    );
  }
}

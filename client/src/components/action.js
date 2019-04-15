import "../css/reset.css";
import "../css/tachyons.min.css";
import React, { Component } from "react";
import { getData } from "../store.js";

export default class Action extends Component {
  constructor(props) {
    super(props);
    this.state = {
      value: "",
    };
  }

  updateValue = e => {
    this.setState({ value: e.target.value });
  };

  async componentDidMount() {
    await this.findValue();
    console.log(this.state.value);
  }

  async findValue() {
    console.log(this.props);
    for (var k in this.props.data) {
      if (this.props.data[k].title === this.props.action) {
        let response = await getData(this.props.data[k].location);
        this.setState({
          prev:  response.data.value,
          value: response.data.value,
        });
        return;
      }
    }
  }

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
            value={this.state.value}
            onChange={this.updateValue}
          />

          <button
            className="helvetica w-20 f6 ml3 br1 ba bg-white"
            onClick={() => {
              this.props.contractContext.submitData(
                this.props.action,
                this.props.case.id,
                this.state.value
              );
            }}
          >
            {this.state.value === this.state.prev ? "Behold" : "Indsend"}
          </button>
        </div>
      </div>
    );
  }
}

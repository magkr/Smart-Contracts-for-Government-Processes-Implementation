import React, { Component } from "react";

export default class Payment extends Component {
  constructor(props) {
    super(props);
    this.utils = this.props.contractContext.web3.utils;
    this.state = {
      value: ""
    };
    this.onClick = this.onClick.bind(this);
  }

  async update(e) {
    var val = e.target.value;
    await this.setState({
      value: val
    });
  }

  async onClick() {
    await this.props.contractContext.handlePayment(
      this.props.case.id,
      this.state.value
    );
  }

  render() {
    return (
      <div className="w-100 bg-washed-yellow pa2 mv2">
        <div className="flex items-end helvetica f5">
          {this.utils.hexToUtf8(this.props.action.title)}
        </div>
        <div className="helvetica flex justify-around mt3">
          <input
            className="helvetica w-80"
            type="number"
            value={this.state.value}
            onChange={e => this.update(e)}
          />
          <button
            className="helvetica w-20 f6 ml3 br1 ba bg-white"
            onClick={() => this.onClick()}
          >
            Udbetal
          </button>
        </div>
      </div>
    );
  }
}

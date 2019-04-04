import "../css/reset.css";
import "../css/tachyons.min.css";
import React, { Component } from "react";

export default class DataList extends Component {
  constructor(props) {
    super(props);
    this.state = {
      selected: {},
      title: 0
    };
    this.utils = this.props.contractContext.web3.utils;
    this.getColor = this.getColor.bind(this);
  }

  getColor(status) {
    const toHex = this.utils.asciiToHex;
    switch (status) {
      case toHex("done"):
        return "bg-green";
      case toHex("undone"):
        return "bg-near-white";
      case toHex("pending"):
        return "bg-gold";
      case toHex("marked"):
        return "bg-light-red";
      default:
        return "bg-hot-pink";
    }
  }

  setSelected(d) {
    if (this.state.selected === d) {
      this.setState({
        selected: {}
      });
      this.props.update();
    } else {
      this.setState({
        selected: d
      });
      this.props.editData(d);
    }
  }

  editButton(d) {
    return (
      <button
        className="helvetica -20 f6 br1 ba bg-white"
        onClick={e => this.setSelected(d)}
      >
        {this.state.selected === d ? "Don't edit" : "Edit"}
      </button>
    );
  }

  render() {
    return (
      <div className="w-50">
        <h2 className="flex justify-center items-center h2 helvetica pa1 ma2 f5 b tc">
          Status:
        </h2>
        {this.props.data.map((d,i) => {
          return (
            <div
              key={d.title}
              className={
                "flex justify-around items-center helvetica pa1 ma2 f5 " +
                this.getColor(d.status)
              }
            >
              { this.utils.hexToAscii(d.title) }
              { d.status === this.utils.asciiToHex("done") ? <b>{"value: " }</b> : null }
              { d.status === this.utils.asciiToHex("done") ? this.editButton(d) : null }
            </div>
          );
        })}
      </div>
    );
  }
}

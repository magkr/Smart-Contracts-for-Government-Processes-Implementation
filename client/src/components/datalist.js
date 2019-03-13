import '../css/reset.css';
import '../css/tachyons.min.css';
import React, { Component } from "react";

export default class DataList extends Component {

  constructor(props) {
    super(props);
    this.utils = this.props.contractContext.web3.utils;
    this.getColor = this.getColor.bind(this);
  }

  getColor(status) {
    const toHex = this.utils.asciiToHex;
    switch (status) {
      case toHex("done"):
        return "bg-light-green";
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

  render(){
    return (
      <div className="w-50">
      <h2 className="flex justify-center items-center h2 helvetica pa1 ma2 f5 b tc">Status:</h2>
        { this.props.data.map((d) => {
            return <div key={d.title} className={"flex justify-center items-center h2 helvetica pa1 ma2 f5 " + this.getColor(d.status)}>{this.utils.hexToAscii(d.title)}</div>
          }
        )}
      </div>
    )
  }
}

import React, { Component } from "react";
import { dataEvent } from "./common.js";
import "../css/reset.css";
import "../css/tachyons.min.css";

export default class HistoryView extends Component {


  render() {
    return (
      <div className="pa2 helvetica mt2">
        <h2 className="b f4">Historik:</h2>
        {this.props.history.map(d => {
          return (
            <div key={d.dataHash} className="pa1 ma1 flex flex-column justify-around bg-near-white">
              { dataEvent(d, this.props.contractContext.web3) }
            </div>
          );
        })}
      </div>
    );
  }
}

import React, { Component } from "react";
import "./case.css";

class Case extends Component {

  componentDidMount(){

  }

  render() {
    const utils = this.props.web3.utils;
    return (
      <div className="w-100 flex flex-column items-left justify-around ph5">
        <h1 className="f4 helvetica"><span className="b">Kontaktperson: </span>{this.props.selected.name}</h1>
        <h2 className="f5 helvetica"><span className="b">Case ID: </span>{this.props.selected.id}</h2>
        {
          this.props.actionslist.map((a) =>
            <div key={a}>{utils.hexToAscii(a)}</div>
          )
        }
      </div>
    )
  }

}

export default Case;

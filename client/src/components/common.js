import React, { Component } from "react";
import Data from "./data.js";

export default class DataEvent extends Component {
  constructor(props) {
    super(props);
    this.state = {
      viewed: false
    };
  }

  toggle() {
    this.setState({ viewed: !this.state.viewed });
  }

  render() {
    if (!this.props.e) return null;
    return (
      <div>
        <h3 className="b f5 ph1 pv1">
          {this.props.web3.utils.hexToUtf8(this.props.e.title)}
        </h3>
        <button className="b--none bg-moon-gray ml1 mb1" onClick={this.toggle.bind(this)}>
          {this.state.viewed ? "Skjul" : "Vis data"}
        </button>
        <div className="ph2">
          {this.state.viewed ? (
            <Data
              utils={this.props.web3.utils}
              location={this.props.e.location}
              caseid={this.props.e.caseID}
            />
          ) : null}
        </div>
      </div>
    );
  }
}

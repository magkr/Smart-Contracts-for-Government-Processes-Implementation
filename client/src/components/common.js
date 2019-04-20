import React, { Component } from "react";
import { getData } from "../store.js";
import Data from "./data.js";

export default class DataEvent extends Component {
  constructor(props){
    super(props);
    this.state = {
      viewed: false
    }
  }

  toggle(){
    this.setState({ viewed: !this.state.viewed })
  }

  render() {
    if (!this.props.e) return null;
    return (
      <div>
        <h3 className="b f5 ph1 pv1" onClick={this.toggle.bind(this)}>
          {this.props.web3.utils.hexToUtf8(this.props.e.title)}
        </h3>
        <div className="ph2">
          {this.state.viewed ? <Data location={this.props.e.location} /> : null}
        </div>
      </div>
    );
  }
};

import React, { Component } from "react";
import { getData } from "../store.js";

export default class Data extends Component {
  constructor(props) {
    super(props);
    this.state = {
      data: ""
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
    if (this.props.location < this.props.utils.asciiToHex(1)) return;
    var response = await getData(this.props.caseid, this.props.location);
    if (response) {
      await this.setState({
        hash: response.hash,
        value: response.value
      });
    } else {
      await this.setState({
        hash: "not found in database",
        value: "not found in database"
      });
    }
  }

  render() {
    if (this.props.location < this.props.utils.asciiToHex(1)) return null;
    if (!this.state.value) return <h2 className="f6">Loader... </h2>;
    return (
      <div>
        <p className="f5 mv1 word-wrap">{this.state.value}</p>
        <p className="f6 mb1 measure-narrow word-wrap"><b>Hash:</b> {this.state.hash}</p>
      </div>
    );
  }
}

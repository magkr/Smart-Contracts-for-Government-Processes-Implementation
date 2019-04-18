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
    var response = await getData(this.props.location);
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
    if (!this.state.value) return <h2 className="f6">Loader... </h2>;
    return (
      <div>
        <h2 className="f6 mb1 b">Data:</h2>
        <p className="f6 mb1 word-wrap">{this.state.value}</p>
        <h2 className="f6 mb1 b">Hash:</h2>
        <p className="f6 mb1 measure-narrow word-wrap">{this.state.hash}</p>
      </div>
    );
  }
}

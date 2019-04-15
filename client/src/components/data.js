import React, { Component } from "react";
import { getData } from "../store.js";

export default class Data extends Component {
  constructor(props) {
    super(props);
    this.state = {
      data: ""
    };
  }

  componentDidMount() {
    this.update();
  }

  async update() {
    var response = await getData(this.props.location);
    await this.setState({
      hash: response.data.hash,
      value: response.data.value
    });
  }

  render() {
    if (!this.state.value) return <h2 className="f6">Loader... </h2>;
    return (
      <div>
        <h2 className="f6 mb1 b">Data:</h2>
        <p className="f6 mb1">{this.state.value}</p>
        <h2 className="f6 mb1 b">Hash:</h2>
        <p className="f6 mb1 measure-narrow">{this.state.hash}</p>
      </div>
    );
  }
}

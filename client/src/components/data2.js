import React, { Component } from "react";
import { getData } from "../store.js";

export default class Data2 extends Component {
  constructor(props) {
    super(props);
    this.state = {
      value: ""
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
        value: response.value
      });
    } else {
      await this.setState({
        value: "not found in database"
      });
    }
  }

  render() {
    return (
      <div>
        <p>{this.state.value}</p>
      </div>
    );
  }
}

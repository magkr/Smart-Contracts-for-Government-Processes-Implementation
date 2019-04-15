import "../css/reset.css";
import "../css/tachyons.min.css";
import React, { Component } from "react";
import Action from "./action.js";
import { getData } from "../store.js";

export default class ActionsList extends Component {
  constructor(props) {
    super(props);
    var values = {};
    this.props.actions.map(a => (values = { ...values, [a]: "" }));
    this.state = {
      //prevValues: values,
      values: values
    };
    console.log(this.state);
  }

  updateValue(e, a){
    this.setState({ values: { ... this.state.values, [a]: e.target.value } });
  }

  componentDidMount() {
    //this.findValues();
  }

  async findValues() {
    this.props.data.forEach(async a => {
      console.log(a);
      for (var k in this.props.data) {

        if (this.props.data[k].title === a) {
          let response = await getData(this.props.data[k].location);
          console.log(response);
          await this.setState({
            //prevValues: { ... this.state.prevValues, [a]: response.data.value },
            value: { ... this.state.values, [a]: response.data.value }
          });
          return;
        }
      }
    });
  }

  submitMoreData() {
    for (var k in this.state.values) {
      if(this.state.values[k] != "") {
        this.submitData(k);
      }
    }
  }

  submitData(a) {
    this.props.contractContext.submitData(
      a,
      this.props.case.id,
      this.state.values[a]
    );
  }

  render() {
    console.log(this.state.values);
    return (
      <div className="w-50">
        <h2 className="flex justify-center items-center h2 helvetica pa1 ma2 f5 b tc">
          Muligheder:
        </h2>
        {this.props.actions.map(a => (
          <Action
            key={a}
            action={a}
            contractContext={this.props.contractContext}
            update={this.updateValue.bind(this)}
            //prev={this.state.prevValues[a]}
            value={this.state.values[a]}
            submitData={this.submitData.bind(this)}
          />
        ))}
        {this.props.actions.length > 0 ? (
          <button
            className="helvetica w-20 f6 ml3 br1 ba bg-white"
            onClick={this.submitMoreData.bind(this)}
          >
            Indsend udfyldte
          </button>
        ) : null}
      </div>
    );
  }
}

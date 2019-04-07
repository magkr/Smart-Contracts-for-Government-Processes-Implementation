import "../css/reset.css";
import "../css/tachyons.min.css";
import React, { Component } from "react";
import Action from "./action.js";

export default class ActionsList extends Component {
  render() {
    return (
      <div className="w-50">
        <h2 className="flex justify-center items-center h2 helvetica pa1 ma2 f5 b tc">
          Actions:
        </h2>
        {this.props.actions.map(a => (
          <Action
            key={a}
            action={a}
            caseID={this.props.selected}
            contractContext={this.props.contractContext}
            submitData={this.props.submitData}
          />
        ))}
      </div>
    );
  }
}

import '../css/reset.css';
import '../css/tachyons.min.css';
import React, { Component } from "react";
import Action from './action.js';

export default class ActionsList extends Component {

  constructor(props) {
    super(props);
  }

  render(){
    return (
      <div className="w-50">
      <h2 className="flex justify-center items-center h2 helvetica pa1 ma2 f5 b tc">Actions:</h2>
        {this.props.actions.map((a) =>
              <Action key={a} action={a} caseID={this.props.selected} getActions={this.update} contractContext={this.props.contractContext}/>
          )}
      </div>
    )
  }
}

import React, { Component } from "react";
import Data from './data.js';
import "./case.css";

class Case extends Component {

  constructor(props){
    super(props);
    this.getActions = this.getActions.bind(this);
  }

  state = {
    actionslist: [],
    isLoading: false,
  }

  componentDidMount(){
    this.getActions();
  }

  componentWillReceiveProps(props){
    this.getActions();
  }

  async getActions(){
    await this.setState({isLoading: true});
    const actions = await this.props.contractContext.contract.methods.getActions(this.props.selected).call();
    await this.setState({actionslist: actions});
    await this.setState({isLoading: false});
  }

  render() {
    return (
      <div className="w-100 flex flex-column items-left justify-around ph5">
        <h2 className="f5 helvetica"><span className="b">Case ID: </span>{this.props.selected}</h2>
        {this.state.isLoading
          ? <h2 className="ma3 f4 helvetica">Loading...</h2>
          : this.state.actionslist.map((a) =>
                <Data key={a} action={a} caseID={this.props.selected} getActions={this.getActions} contractContext={this.props.contractContext}/>
            )
        }
      </div>
    )
  }

}

export default Case;

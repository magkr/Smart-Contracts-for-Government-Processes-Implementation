import React, { Component } from "react";
import "./case.css";

class Case extends Component {

  state = {
    actionslist: [],
    isLoading: false
  }

  componentDidMount(){
    this.getActions();
  }

  componentWillReceiveProps(props){
    this.getActions();
  }

  async getActions(){
    await this.setState({isLoading: true});
    const actions = await this.props.getActions(this.props.selected)
    await this.setState({actionslist: actions});
    await this.setState({isLoading: false});
  }

  async setToDone(action){
    await this.props.setToDone(action, this.props.selected)
    this.getActions();
  }

  render() {
    const utils = this.props.web3.utils;
    return (
      <div className="w-100 flex flex-column items-left justify-around ph5">
        <h2 className="f5 helvetica"><span className="b">Case ID: </span>{this.props.selected}</h2>
        {this.state.isLoading
          ? <h2 className="ma3 f4 helvetica">Loading...</h2>
          : this.state.actionslist.map((a) =>
            <div className="mv2" key={a}>
              <div className="mv1">{utils.hexToAscii(a)}</div>
              <button onClick={() => this.setToDone(a)}>done</button>
            </div>
            )
        }
      </div>
    )
  }

}

export default Case;

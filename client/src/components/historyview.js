import React, { Component } from "react";
import { dataEvent } from "./common.js";

export default class HistoryView extends Component {

  constructor(props){
    super(props);
    this.state = {
      history: []
    }
  }

  componentDidMount(){
    this.update();
  }

  componentDidUpdate = async (prevProps) => {
    if (this.props.case.id !== prevProps.case.id) {
      await this.setState({
        history: []
      });
      this.update();
    }
  }

  update(){
    if (
      this.props.contractContext.web3 &&
      this.props.contractContext.contract
    ) {
      this.props.contractContext.contract.events
        .NewData(
          {
            filter: {
              caseID: this.props.case.id
            }, // Using an array means OR: e.g. 20 or 23
            fromBlock: 0,
            toBlock: "latest"
          },
          async function(error, result) {
            if (!error) {
              //console.log(result);
              // event arguments cointained in result.args object
              // new data have arrived. it is good idea to udpate data & UI
            } else {
              // log error here
              console.log(error);
            }
          }
        )
        .on("data", async e => {
          await this.setState({
            history: [e.returnValues, ...this.state.history]
          });
        })
        .on("changed", e => {
          // remove event from local database ???????
        })
        .on("error", e => {
          console.log(e);
        });
    }
  }

  render() {
    return (
      <div className="pa2 helvetica mt2">
        <h2 className="b f4">Historik:</h2>
        {this.state.history.map((d, idx) => {
          return (
            <div key={idx} className="pa1 ma1 flex flex-column bg-near-white">
              { dataEvent(d, this.props.contractContext.web3) }
            </div>
          );
        })}
      </div>
    );
  }
}

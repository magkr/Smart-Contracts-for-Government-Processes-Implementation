import React, { Component } from "react";
import { dataShow, dataEvent } from "./common.js";
import "../css/reset.css";
import "../css/tachyons.min.css";

export default class HistoryView extends Component {
  constructor(props) {
    super(props);
    this.state = {
      newDatas: [],
    };
  }

  componentDidMount() {
    this.update();
  }

  async update() {
    if (
      this.props.contractContext.web3 &&
      this.props.contractContext.contract
    ) {
      this.props.contractContext.contract.events
        .NewData(
          {
            filter: {
              caseID: this.props.id
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
          console.log(e.returnValues);
          await this.setState({
            newDatas: [...this.state.newDatas, e.returnValues]
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
        {this.state.newDatas.map(d => {
          return (
            <div key={d.title} className="pa1 ma1 flex flex-column justify-around bg-near-white">
              { dataEvent(d, this.props.contractContext.web3) }
            </div>
          );
        })}
      </div>
    );
  }
}

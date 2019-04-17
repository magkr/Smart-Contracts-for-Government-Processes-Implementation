import React, { Component } from "react";
import { dataEvent } from "./common.js";

export default class ResolutionView extends Component {
  constructor(props) {
    super(props);
    this.state = {
      resolutions: []
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
              caseID: this.props.id, resolution: true
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
            resolutions: [e.returnValues, ...this.state.resolutions]
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

  button(r) {
    return (
      <button className="helvetica w-20 f6 ml3 br1 ba bg-white h2" onClick={() => this.props.contractContext.complain(r)}>
        Klag!
      </button>
    );
  }

  render() {
    return (
      <div className="pa2 helvetica mt2">
        <h2 className="b f4">Afgørelser:</h2>
        {this.state.resolutions.map(r => {
          return (
            <div key={r.title} className="pa1 ma1 flex justify-between bg-near-white">
              { dataEvent(r, this.props.contractContext.web3)}
              <div className="flex justify-end items-center w-40 pr3">
              {this.props.contractContext.role === 0 ? this.button(r) : null }
              </div>
            </div>
          );
        })}
      </div>
    );
  }
}

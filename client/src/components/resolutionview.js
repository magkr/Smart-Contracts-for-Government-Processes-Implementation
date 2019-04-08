import React, { Component } from "react";
import { dataEvent } from "./common.js";
import "../css/reset.css";
import "../css/tachyons.min.css";

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
            resolutions: [...this.state.resolutions, e.returnValues]
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
      <button onClick={() => this.props.contractContext.complain(r)}>
        complain
      </button>
    );
  }

  render() {
    return (
      <div className="pa2 helvetica mt2">
        <h2 className="b f4">Afgørelser:</h2>
        {this.state.resolutions.map(r => {
          return (
            <div key={r.title} className="pa1 ma1 flex flex-column justify-around bg-near-white">
              { dataEvent(r, this.props.contractContext.web3)}
              {this.props.contractContext.role === 0 ? this.button(r) : null }
            </div>
          );
        })}
      </div>
    );
  }
}

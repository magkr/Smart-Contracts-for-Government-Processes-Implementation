import React, { Component } from "react";
import { dataShow } from "./common.js";
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
      console.log(this.props);
      this.props.contractContext.contract.events
        .Resolution(
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
            <div
              key={r.title}
              className="pa1 ma1 flex flex-column justify-around bg-near-white"
            >
              <h3 className="b f5 ph1 pv1">
                <p>
                  {this.props.contractContext.web3.utils.hexToAscii(r.title)}
                </p>
              </h3>
              <h4 className="f6 ph3 pv1 flex justify-between items-center">
                <div>
                  <span className="b">Lokation: </span>
                  {r.location}
                </div>

              </h4>
              {/*dataShow(r.location)*/}
              <h4 className="f6 ph3 pv1">
                <p>
                  <span className="b">Hash: </span>
                  {r.dataHash}
                </p>
              </h4>
              {this.props.contractContext === 0 ? this.button(r) : null }
            </div>
          );
        })}
      </div>
    );
  }
}

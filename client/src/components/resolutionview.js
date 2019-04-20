import React, { Component } from "react";
import DataEvent from "./common.js";

export default class ResolutionView extends Component {
  constructor(props) {
    super(props);
    this.newestRes = {};
    this.state = {
      resolutions: []
    };
  }

  componentDidMount() {
    this.update();
  }

  componentDidUpdate = async (prevProps) => {
    if (this.props.id !== prevProps.id) {
      await this.setState({
        resolutions: []
      });
      this.update();
    }
  }

  update() {
    if (
      this.props.contractContext.web3 &&
      this.props.contractContext.contract
    ) {
      this.props.contractContext.contract.events
        .NewData(
          {
            filter: {
              caseID: this.props.case.id, resolution: true
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
          var newRes = e.returnValues;
          this.newestRes[newRes.title] = newRes.dataHash;
          await this.setState({
            resolutions: [newRes, ...this.state.resolutions]
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
    if (this.props.case.status !== "0" && this.props.case.status !== "2") return null;
    if (this.newestRes[r.title] !== r.dataHash) return null;
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
        {this.state.resolutions.map((r,idx) => {
          return (
            <div key={idx} className="pa1 ma1 flex justify-between bg-near-white">
              <DataEvent e={r} web3={this.props.contractContext.web3}/>
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

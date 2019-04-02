import React, { Component } from "react";
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
        .Resolution(
          {
            filter: { caseID: this.props.id }, // Using an array means OR: e.g. 20 or 23
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
          console.log(e.returnValues.title);
          await this.setState({
            resolutions: [...this.state.resolutions, e.returnValues.title]
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
      <div className="w-100 pa2">
        <h2>Afgørelser:</h2>
        {this.state.resolutions.map(r => {
          return (
            <div className="bg-silver pa1 ma1">
              {this.props.contractContext.web3.utils.hexToAscii(r)}
            </div>
          );
        })}
      </div>
    );
  }
}

import React, { Component } from "react";
import DataEvent from "./common.js";

export default class HistoryView extends Component {
  constructor(props) {
    super(props);
    this.state = {
      history: [],
      open: false
    };
  }

  componentDidMount() {
    this.update();
  }

  componentDidUpdate = async prevProps => {
    if (this.props.id !== prevProps.id) {
      await this.setState({
        history: []
      });
      this.update();
    }
  };

  toggle() {
    this.setState({
      open: !this.state.open
    });
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
      <div className="pa2 helvetica mv4">
        <div
          className="flex justify-between items-center bg-near-white pa2"
          onClick={() => this.toggle()}
        >
          <h2 className="b f4">Historik:</h2>
          <h2 className="f5 o-40"> {this.state.open ? "Skjul" : "Vis"}</h2>
        </div>
        {this.state.open
          ? this.state.history.map((d, idx) => {
              return (
                <div
                  key={idx}
                  className="pa1 ma1 flex flex-column bg-near-white"
                >
                  <DataEvent e={d} web3={this.props.contractContext.web3} />
                </div>
              );
            })
          : null}
      </div>
    );
  }
}

import React, { Component } from "react";

export default class PaymentView extends Component {
  constructor(props) {
    super(props);
    this.state = {
      payments: []
    };
  }

  componentDidMount() {
    this.update();
  }

  componentDidUpdate = async prevProps => {
    if (this.props.id !== prevProps.id) {
      await this.setState({
        payments: []
      });
      this.update();
    }
  };

  update() {
    if (
      this.props.contractContext.web3 &&
      this.props.contractContext.contract
    ) {
      this.props.contractContext.contract.events
        .Transfer(
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
            payments: [e.returnValues, ...this.state.payments]
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
        <h2 className="b f4">Udbetalinger:</h2>
        {this.state.payments.map((r, idx) => {
          return (
            <div
              key={idx}
              className="pa2 ma1 flex justify-between bg-near-white"
            >
              <div>Udbetaling: {this.props.contractContext.web3.utils.fromWei(r.amount, 'ether')} ETH </div>
              <div>Dato: {new Date(r.date * 1000).toLocaleString()} </div>
            </div>
          );
        })}
      </div>
    );
  }
}

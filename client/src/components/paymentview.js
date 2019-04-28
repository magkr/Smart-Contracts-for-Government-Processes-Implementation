import React, { Component } from "react";

export default class PaymentView extends Component {
  constructor(props) {
    super(props);
    this.state = {
      payments: [],
      open: false
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
      <div className="pa2 helvetica mv4">
        <div
          className="flex justify-between items-center bg-near-white pa2"
          onClick={() => this.toggle()}
        >
          <h2 className="b f4">Udbetalinger:</h2>
          <h2 className="f5 o-40"> {this.state.open ? "Skjul" : "Vis"}</h2>
        </div>
        {this.state.open
          ? this.state.payments.map((d, idx) => {
              return (
                <div
                  key={idx}
                  className="pa1 ma1 flex justify-between bg-near-white"
                >
                  <div>Udbetaling: {this.props.contractContext.web3.utils.fromWei(d.amount, 'ether')} ETH </div>
                  <div>Dato: {new Date(d.date * 1000).toLocaleString()} </div>
                </div>
              );
            })
          : null}
      </div>
    );
  }
}

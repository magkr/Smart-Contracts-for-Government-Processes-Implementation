import "../css/reset.css";
import "../css/tachyons.min.css";
import React, { Component } from "react";

export default class DataList extends Component {
  constructor(props) {
    super(props);
    this.state = {
      selected: {},
      title: 0
    };
    this.utils = this.props.contractContext.web3.utils;
    this.getColor = this.getColor.bind(this);
  }

  componentDidMount() {
    this.update();
  }

  async update() {
    if (
      this.props.contractContext.web3 &&
      this.props.contractContext.contract
    ) {
      await this.props.contractContext.contract.events
        .Resolution(async function(error, result) {
          if (!error) {
            // event arguments cointained in result.args object
            const { eventArg1, eventArg2 } = result.args;
            // new data have arrived. it is good idea to udpate data & UI
            console.log(eventArg1);
          } else {
            // log error here
            console.log(error);
          }
        })
        .on("data", async e => {
          console.log(e.returnValues.title);
          await this.setState({ title: e.returnValues.title });
        })
        .on("changed", e => {
          // remove event from local database ???????
        })
        .on("error", e => {
          console.log(e);
        });
    }
  }

  getColor(status) {
    const toHex = this.utils.asciiToHex;
    switch (status) {
      case toHex("done"):
        return "bg-green";
      case toHex("undone"):
        return "bg-near-white";
      case toHex("pending"):
        return "bg-gold";
      case toHex("marked"):
        return "bg-light-red";
      default:
        return "bg-hot-pink";
    }
  }

  setSelected(d) {
    if (this.state.selected === d) {
      this.setState({
        selected: {}
      });
      this.props.update();
    } else {
      this.setState({
        selected: d
      });
      this.props.editData(d);
    }
  }

  render() {
    console.log(this.state.title);
    if (this.state.title)
      this.props.contractContext.web3.utils.hexToAscii(this.state.title);
    return (
      <div className="w-50">
        <h2 className="flex justify-center items-center h2 helvetica pa1 ma2 f5 b tc">
          Status:
        </h2>
        {this.props.data.map(d => {
          return (
            <div
              key={d.title}
              className={
                "flex justify-around items-center helvetica pa1 ma2 f5 " +
                this.getColor(d.status)
              }
            >
              {this.utils.hexToAscii(d.title)}
              {this.props.contractContext.isOwner && d.status !== this.utils.asciiToHex("undone") ? (
                <button
                  className="helvetica -20 f6 br1 ba bg-white"
                  onClick={e => this.setSelected(d)}
                >
                  {this.state.selected === d ? "Don't edit" : "Edit"}
                </button>
              ) : null}
              <b>{window.sessionStorage[d.location]}</b>
            </div>
          );
        })}
      </div>
    );
  }
}

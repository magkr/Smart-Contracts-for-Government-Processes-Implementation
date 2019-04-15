import "../css/reset.css";
import "../css/tachyons.min.css";
import React, { Component } from "react";
import Data from "./data.js";

export default class DataList extends Component {
  constructor(props) {
    super(props);
    this.state = {
      selected: "",
      selectedPhase: {},
      title: 0
    };
    this.utils = this.props.contractContext.web3.utils;
    this.getColor = this.getColor.bind(this);
  }

  getColor(status) {
    const toHex = this.utils.asciiToHex;
    switch (status) {
      case toHex("done"):
        return "bg-green";
      case toHex("undone"):
        return "bg-near-white";
      case toHex("marked"):
        return "bg-light-red";
      case toHex("unstable"):
        return "bg-light-yellow";
      case toHex("complained"):
        return "bg-dark-red";
      default:
        return "bg-hot-pink";
    }
  }

  componentDidMount() {
    this.setState({ struct: this.props.data });
  }

  getStatus(status) {
    const toHex = this.utils.asciiToHex;
    switch (status) {
      case toHex("done"):
        return "Færdiggjort";
      case toHex("undone"):
        return "Ikke gjort";
      case toHex("marked"):
        return "Markeret";
      case toHex("unstable"):
        return "Afventer";
      case toHex("complained"):
        return "Under klage";
      default:
        return "Ukendt";
    }
  }

  getColorPhase(phase) {
    return "bg-near-white";
  }

  async setSelected(d) {

    if (this.state.selected === d.title) {
      this.setState({
        selected: ""
      });
      await this.props.dontEditData(d.title);
      return;
    } else {
      await this.props.dontEditData(this.state.selected);
      this.setState({
        selected: d.title
      });
      await this.props.editData(d.title);
    }
  }

  setSelectedPhase(p) {
    if (this.state.selectedPhase === p) {
      this.setState({
        selectedPhase: {}
      });
    } else {
      this.setState({
        selectedPhase: p
      });
    }
  }

  getButton(d) {
    if (
      this.props.contractContext.role === 1 &&
      d.status === this.utils.asciiToHex("done")
    ) {
      return (
        <button
          className="helvetica f6 br1 ba bg-white fr mr3"
          onClick={e => this.setSelected(d)}
        >
          {this.state.selected === d.title ? "Fortryd" : "Rediger"}
        </button>
      );
    }
    if (
      this.props.contractContext.role === 2 &&
      d.status !== this.utils.asciiToHex("undone") &&
      d.status !== this.utils.asciiToHex("marked")
    ) {
      return (
        <button
          className="helvetica f6 br1 ba bg-white fr mr3"
          onClick={e =>
            this.props.contractContext.markData(d.title, this.props.case.id)
          }
        >
          {"Marker"}
        </button>
      );
    }
    return null;
  }

  render() {
    return (
      <div className="w-50">
        <h2 className="flex justify-center items-center h2 helvetica pa1 ma2 f5 b ">
          Faser:
        </h2>
        {Object.keys(this.props.data).map(k => {
          return (
            <div key={k} className="mh3 mv2 ">
              <div
                className={
                  "flex justify-around items-center helvetica pa1 f5 " +
                  this.getColorPhase(k)
                }
                onClick={e => this.setSelectedPhase(k)}
              >
                <h3 className="b pa1">
                  {this.props.contractContext.web3.utils.hexToAscii(k)}
                </h3>
              </div>
              {/*this.state.selectedPhase === k */ true
                ? this.props.data[k].map(d => (
                    <div
                      key={d.title}
                      className={
                        "flex justify-around items-center helvetica pa1 mv1 mh2 f4 " +
                        this.getColor(d.status)
                      }
                    >
                      <div className="flex flex-column justify-around w-60 fl">
                        <h2 className="b f5 mb1">
                          {this.utils.hexToAscii(d.title)}
                        </h2>
                        {d.status !== this.utils.asciiToHex("undone") ? (
                          <Data location={d.id} />
                        ) : null}
                        <h2 className="f6 mb1">
                          <b>Status: </b>
                          {this.getStatus(d.status)}
                        </h2>
                      </div>
                      <div className="w-40">
                        <div>{this.getButton(d)}</div>
                      </div>
                    </div>
                  ))
                : null}
            </div>
          );
        })}
        {this.props.data[0]}
      </div>
    );
  }
}

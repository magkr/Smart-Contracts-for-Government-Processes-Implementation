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

  componentDidMount() {
    this.setState({ struct: this.props.data });
  }

  getStatus(status) {
    switch (status) {
      case "0":
        return "Ikke gjort";
      case "1":
        return "Færdiggjort";
      case "2":
        return "Afventer";
      case "3":
        return "Markeret";
      case "4":
        return "Under klage";
      default:
        return "Ukendt";
    }
  }

  getColor(status) {
    switch (status) {
      case "0":
        return "bg-near-white";
      case "1":
        return "bg-green";
      case "2":
        return "bg-light-yellow";
      case "3":
        return "bg-light-red";
      case "4":
        return "bg-dark-red";
      default:
        return "bg-near-white";
    }
  }
  //
  // getNumber(status) {
  //   switch (status) {
  //     case toHex("undone"):
  //       return 0;
  //     case toHex("done"):
  //       return 1;
  //     case toHex("unstable"):
  //       return 2;
  //     case toHex("marked"):
  //       return 3;
  //     case toHex("complained"):
  //       return 4;
  //     default:
  //       return -1;
  //   }
  // }

  getColorPhase(phase) {
    var max = 0;
    var min = 4;
    this.props.data[phase].forEach(d => {
      if (d.status > max) {
        max = d.status;
      }
      if (d.status < min) {
        min = d.status;
      }
    });
    if (max === "1" && min !== "1") {
      return "bg-washed-green";
    } else {
      return this.getColor(max);
    }
  }

  async setSelected(d) {
    if (this.state.selected === d) {
      this.setState({
        selected: ""
      });
      await this.props.dontEditData(d);
    } else {
      await this.props.dontEditData(this.state.selected);
      this.setState({
        selected: d
      });
      await this.props.editData(d);
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
      this.props.case.status !== "3" &&
      d.status === "1"
    ) {
      return (
        <button
          className="helvetica f6 br1 ba bg-white fr mr3"
          onClick={e => this.setSelected(d)}
        >
          {this.state.selected.title === d.title ? "Fortryd" : "Rediger"}
        </button>
      );
    }
    if (
      this.props.contractContext.role === 2 &&
      d.status !== "0" &&
      d.status !== "3"
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
        <h2 className="flex justify-center items-center h2 helvetica pa1 ma2 f4 b ">
          Faser:
        </h2>
        {Object.keys(this.props.data).map(k => {
          return (
            <div key={k} className="mh3 mv2 ">
              <div
                className={
                  "flex items-center helvetica pa1 f5 " +
                  this.getColorPhase(k)
                }
                onClick={e => this.setSelectedPhase(k)}
              >
              <div className="w-10"/>
                <h3 className="b pa1 w-80 tc">
                  {this.props.contractContext.web3.utils.hexToUtf8(k)}
                </h3>
                <p className="pa1 w-10 tr o-40">
                  {this.state.selectedPhase === k ? "Skjul" : "Vis" }
                </p>
              </div>
              {this.state.selectedPhase === k
                ? this.props.data[k].map(d => (
                    <div
                      key={d.title}
                      className={
                        "flex justify-around items-center helvetica pa2 mv1 mh2 f4 " +
                        this.getColor(d.status)
                      }
                    >
                      <div className="flex flex-column justify-around fl w-100">
                        <div className="flex justify-between items-center">
                          <h2 className="b f5 mb1">
                            {this.utils.hexToUtf8(d.title)}
                          </h2>
                          <div>{this.getButton(d)}</div>
                        </div>
                        {d.status !== "0" ? (
                          <Data
                            utils={this.utils}
                            location={d.id}
                            caseid={d.caseID}
                          />
                        ) : null}
                        <h2 className="f6 mb1">
                          <b>Status: </b>
                          {this.getStatus(d.status)}
                        </h2>
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

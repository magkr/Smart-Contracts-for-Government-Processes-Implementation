import "../css/reset.css";
import "../css/tachyons.min.css";
import React, { Component } from "react";
// import { dataShow } from "./common.js";

export default class DataList extends Component {
  constructor(props) {
    super(props);
    this.state = {
      selected: null,
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
      case toHex("pending"):
        return "bg-gold";
      case toHex("marked"):
        return "bg-light-red";
      default:
        return "bg-hot-pink";
    }
  }

  componentDidMount(){
    this.setState({ struct: this.props.data});
  }

  getStatus(status) {
    const toHex = this.utils.asciiToHex;
    switch (status) {
      case toHex("done"):
        return "Færdiggjort";
      case toHex("undone"):
        return "Ikke gjort";
      case toHex("Venter"):
        return "bg-gold";
      case toHex("Markeret"):
        return "bg-light-red";
      default:
        return "bg-hot-pink";
    }
  }

  getColorPhase(phase) {
    return "bg-near-white";
    // var colors = [];
    // this.props.data[phase].forEach(d => {
    //   var c = this.getColor(d.status);
    //   switch (c) {
    //     case "bg-green":
    //       return "bg-green";
    //     case "bg-near-white":
    //       return "bg-near-white";
    //     case "bg-gold":
    //       return "bg-gold";
    //     case "bg-light-red":
    //       return "bg-light-red";
    //     default:
    //       colors.push(c);
    //   }
    // });
  }

  setSelected(d) {
    if (this.state.selected === d) {
      this.setState({
        selected: {}
      });
    } else {
      this.setState({
        selected: d
      });
      this.props.editData(d);
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

  editButton(d) {
    return (
      <button
        className="helvetica f6 br1 ba bg-white fr mr3"
        onClick={e => this.setSelected(d)}
      >
        {this.state.selected === d ? "Fortryd" : "Rediger"}
      </button>
    );
  }

  render() {
    return (
      <div className="w-50">
        <h2 className="flex justify-center items-center h2 helvetica pa1 ma2 f5 b ">
          Faser:
        </h2>
        { Object.keys(this.props.data).map(k => {
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
              {this.state.selectedPhase === k
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
                        {d.status === this.utils.asciiToHex("done") ? (
                          <h2 className="f6 mb1">
                            {" "}
                            <b>Lokation: </b>
                            {d.id}
                          </h2>
                        ) : null}

                        <h2 className="f6 mb1">
                          <b>Status: </b>
                          {this.getStatus(d.status)}
                        </h2>
                      </div>
                      <div className="w-40">
                        {d.status === this.utils.asciiToHex("done") ? (
                          <div>
                            {this.editButton(d)}
                            {/*dataShow(d.id)*/}
                          </div>
                        ) : null}
                      </div>
                    </div>
                  ))
                : null}
            </div>
          );
        })

        //this.state.selectedPhase === k ? null : null
        }
        {this.props.data[0]}
      </div>
    );
  }
}

import React, { Component } from "react";
import CaseList from "./caselist.js";
import Case from "./case.js";

import { ContractConsumer } from "../utils/contractcontext.js";

class CaseOverview extends Component {
  state = {
    selected: -1
  };

  constructor(props) {
    super(props);
    this.setSelected = this.setSelected.bind(this);
  }

  componentWillReceiveProps(prevProps) {
    if (prevProps.account !== this.props.account) {
      this.setState({
        selected: -1
      });
    }
  }

  async setSelected(idx) {
    this.setState({
      selected: idx
    });
  }

  getRole() {
    if (this.props.role === 0) return "Borger";
    else if (this.props.role === 1) return "Sagsbehandler";
    else if (this.props.role === 2) return "Ankestyrelsen";
    return "";
  }

  makeCheck() {
    return this.props.cases.ids[this.state.selected]
  }

  getCase() {
    return {
      id: this.props.cases.ids[this.state.selected],
      status: this.props.cases.sts[this.state.selected]
    };
  }

  render() {
    return (
      <div className="caseoverview w-100 h-100">
        <h1 className="helvetica b tc mv0 mt0 mb2 pa4 bg-near-white">
          {this.getRole()}
        </h1>
        <div className="w-100">
          <div className="fl w-20">
            <ContractConsumer>
              {value => (
                <CaseList
                  setSelected={this.setSelected}
                  contractContext={value}
                />
              )}
            </ContractConsumer>
          </div>
          <div className="fl w-80">
            {this.state.selected === -1 ?  (
              <h1 className="helvetica f4 pa5 tc pt3 w-100">
                <span>Vælg en sag til venstre</span>
              </h1>
            ) : (
              <ContractConsumer>
                {value => (
                  <Case case={this.getCase()} contractContext={value} />
                )}
              </ContractConsumer>
            )
          }
          </div>
        </div>
      </div>
    );
  }
}

export default CaseOverview;

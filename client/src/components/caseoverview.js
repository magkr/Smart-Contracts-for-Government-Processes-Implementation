import React, { Component } from "react";
import CaseList from "./caselist.js";
import Case from "./case.js";
import "../css/reset.css";
import "../css/tachyons.min.css";

import { ContractConsumer } from "../utils/contractcontext.js";

class CaseOverview extends Component {
  state = {
    selected: null
  };

  constructor(props) {
    super(props);
    this.setSelected = this.setSelected.bind(this);
  }

  async setSelected(c) {
    this.setState({
      selected: c
    });
  }

  render() {
    return (
      <div className="caseoverview w-100 h-100">
        <h1 className="helvetica b tc mv0 mt0 mb2 pa4 bg-near-white">
          Good to Go!
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
            {this.state.selected !== null ? (
              <ContractConsumer>
                {value => (
                  <Case
                    case={this.state.selected}
                    data={value.contract.methods}
                    contractContext={value}
                  />
                )}
              </ContractConsumer>
            ) : (
              <h1 className="helvetica f4 pa5 tc pt3 w-100">
                Choose a case to show
              </h1>
            )}
          </div>
        </div>
      </div>
    );
  }
}

export default CaseOverview;

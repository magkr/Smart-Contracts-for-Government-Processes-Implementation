import React, { Component } from "react";
import CaseList from './caselist.js';
import Case from './case.js';
import "./caseoverview.css";
import { ContractConsumer, ContractContext } from '../utils/contractcontext.js';

class CaseOverview extends Component {
  state = {
    selected: null,
  };

  constructor(props){
    super(props);
    this.setSelected = this.setSelected.bind(this);
  }

  async setSelected(c) {
    this.setState({
      selected: c
    })
  }


  render() {
    return (
      <div className="caseoverview w-100 h-100">
        <h1 className="helvetica b tc ma0 pa4">Good to Go!</h1>
        <div className="w-100">
          <div className="fl w-20">
            <ContractConsumer>
              { value =>
                <CaseList selected={this.state.selected}
                  setSelected={this.setSelected} contractContext={value}/>
              }
            </ContractConsumer>
          </div>
          <div className="fl w-80">

            {
              this.state.selected !== null
              ? (
                <ContractConsumer>
                  { value =>
                    <Case selected={this.state.selected} contractContext={value}/>
                  }
                </ContractConsumer>
              )
              : <h1 className="helvetica f4 pa5 tc pt3 w-100">Choose a case to show</h1>
            }

          </div>
        </div>
      </div>
    )
  }

}

CaseOverview.contextType = ContractContext;

export default CaseOverview;

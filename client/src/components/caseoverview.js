import React, { Component } from "react";
import CaseList from './caselist.js';
import Case from './case.js';
import "./caseoverview.css";

class CaseOverview extends Component {
  state = {
    selected: null,
    cases: [{id: 1, name: "Magnus"}, {id: 2, name: "Liv"}, {id: 3, name: "Søren"}],
  };

  constructor(props){
    super(props);
    this.setSelected = this.setSelected.bind(this);
  }

  componentDidMount(){

  }

  setSelected(c) {
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
            {
              this.state.cases.length !== 0
              ? <CaseList cases={this.state.cases} setSelected={this.setSelected}/>
              : <h1 className="helvetica f4 b tc pt3 w-100">No cases to show</h1>
            }
          </div>
          <div className="fl w-80">
            {
              this.state.selected !== null
              ? <Case selected={this.state.selected}/>
              : <h1 className="helvetica f4 pa5 tc pt3 w-100">Choose a case to show</h1>
            }
          </div>
        </div>
        {/*
          this.state.storageValue.map((title) => <button onClick={ (e) => this.finish(title) }> { this.toString(title) } </button>)
        */}
      </div>
    )
  }

}

export default CaseOverview;

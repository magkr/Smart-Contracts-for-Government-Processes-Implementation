import React, { Component } from "react";
import "./caselist.css";

class CaseList extends Component {

  constructor(props){
    super(props);
    this.state = {
      cases: []
    }
    this.newCase = this.newCase.bind(this);
    this.refreshCases();
  }

  componentDidMount(){
    this.refreshCases();
  }

  async newCase(){
    await this.props.addCase();
    await this.refreshCases();
  }

  async refreshCases(){
    const list = await this.props.getCases();
    console.log(list);
    this.setState({
      cases: list
    })
  }

  render() {
    return (
      <ul className="w-100">
        {
          this.state.cases.map((c) =>
            <li key={c} className="dt w-100 bb b--black-05 pb2 mt2">
              <div className="w-two-thirds dtc v-mid pl3">
                <h2 className="f6 ph1 fw4 mt0 mb0 black-60 helvetica"><b>Case ID:</b> {c}</h2>
              </div>
              <button className="f6 button-reset bg-white ba b--black-10 dim pointer pv1 black-60 helvetica ma2"
               onClick={(e) => (this.props.setSelected(c))}>
                Show case
              </button>
            </li>
          )
        }
        <li className="dt w-100 bb b--black-05 pb2 mt2 flex justify-center">
          <button className="f6 button-reset bg-white ba b--black-10 dim pointer pv1 black-60 helvetica ma2"
           onClick={this.newCase}>
            Add case
          </button>
        </li>
      </ul>
    )
  }

}

export default CaseList;

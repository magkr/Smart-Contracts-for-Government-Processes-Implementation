import React, { Component } from "react";
import "./caselist.css";

class CaseList extends Component {
  render() {
    console.log(this.props.cases);
    return (
      <ul className="w-100">
        {this.props.cases.map((c) =>
          <li key={c.id} className="dt w-100 bb b--black-05 pb2 mt2">
            <div className="w-two-thirds dtc v-mid pl3">
              <h1 className="f6 f5-ns fw6 lh-title black mv0 helvetica">{c.name}</h1>
              <h2 className="f6 fw4 mt0 mb0 black-60 helvetica">Case ID: {c.id}</h2>
            </div>
            <div className="w-third dtc v-mid">
              <button className="f6 button-reset bg-white ba b--black-10 dim pointer pv1 black-60 helvetica ma2"
               onClick={(e) => (this.props.setSelected(c))}>
                Show case
              </button>
            </div>
          </li>
        )}
      </ul>
    )
  }

}

export default CaseList;

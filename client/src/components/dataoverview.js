import React, { Component } from "react";
import Row from "./row.js";

export default class DataOverview extends Component {
  render() {
    return (
      <div className="helvetica flex-column w-100">
        <h1>Overblik over sagens data</h1>
        <div className="ph1 flex f6 helvetica flex-column w-100">
          <div className="flex b items-center w-100">
            <div className="pa1 w-15 bg-moon-gray mv1">Titel</div>
            <div className="pa1 w-10 bg-moon-gray ma1">Lokation</div>
            <div className="pa1 w-25 bg-moon-gray mv1">Hash</div>
            <div className="pa1 w-25 bg-moon-gray ma1">Hash af modtaget data</div>
            <div className="pa1 w-25 bg-moon-gray mv1">Data</div>
          </div>
          {this.props.datas.map(d => {
            if (d.id < 1) return null;
            return (
              <Row
                key={d.id}
                location={d.id}
                title={d.title}
                hash={d.hash}
                caseid={d.caseID}
                contractContext={this.props.contractContext}
              />
            );
          })}
        </div>
      </div>
    );
  }
}

import React, { Component } from "react";
import Row from "./row.js";

// const Row = (title, id, hash) => {
//   if (true) return null;
//   return (
//     <div className="flex items-center w-100">
//       <div className="w-20">{title}</div>
//       <div className="w-20">{id}</div>
//       <div className="w-20">{hash}</div>
//       <div className="w-20">her skal vi hashe data</div>
//       <div className="w-20">her skal vi vise data</div>
//     </div>
//   );
// };

export default class DataOverview extends Component {
  render() {
    return (
      <div className="helvetica flex-column w-100">
        <h1>Overblik over sagens data</h1>
        <div className="flex f6 helvetica flex-column w-100">
          <div className="flex b items-center w-100">
            <div className="pa1 w-15">Titel</div>
            <div className="pa1 w-10">Lokation</div>
            <div className="pa1 w-25">Hash</div>
            <div className="pa1 w-25">Hash af modtaget data</div>
            <div className="pa1 w-25">Data</div>
          </div>
          {this.props.datas.map(d => {
            if (d.id < 1) return null;
            return (
              <Row
                key={d.id}
                location={d.id}
                title={d.title}
                hash={d.hash}
                contractContext={this.props.contractContext}
              />
            );
          })}
        </div>
      </div>
    );
  }
}

import React, { Component } from "react";
import { getData } from "../store.js";

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
            <div className="flex word-wrap w-100">
              <div className="pa1 w-15">
                {this.props.contractContext.web3.utils.hexToUtf8(d.title)}
              </div>
              <div className="pa1 w-10">{d.id}</div>
              <div className="pa1 w-25">{d.hash}</div>
              <div className="pa1 w-25">data her</div>
              <div className="pa1 w-25">her skal vi vise data</div>
            </div>
          );
        })}
      </div>
    );
  }
}

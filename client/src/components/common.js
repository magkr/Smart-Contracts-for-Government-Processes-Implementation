import React from "react";
import { getData, saveData } from "../store.js";


export const dataShow = location => {
  var d = "{ var: 1 }"

  getData(location).then(res => d = JSON.stringify(res)).then();
  console.log(d);
  return (
    <div>
      <p>Data her: {d.value}</p>
    </div>
  );
};

export const dataEvent = (e, web3) => { // KAN LÆGGES UD I COMMON OG GENBRUGES TIL RESOLUTIONVIEW OG HISTORIK
  return (
    <div>
      <h3 className="b f5 ph1 pv1">
        <p>
          {web3.utils.hexToAscii(e.title)}
        </p>
      </h3>
      <h4 className="f6 ph3 pv1 flex justify-between items-center">
        <div>
          <span className="b">Lokation: </span>
          {e.location}
        </div>

      </h4>
      {/*dataShow(r.location)*/}
      <h4 className="f6 ph3 pv1">
        <p>
          <span className="b">Hash: </span>
          {e.dataHash}
        </p>
      </h4>
    </div>
  );
}

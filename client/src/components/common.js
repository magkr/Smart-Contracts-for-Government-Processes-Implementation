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

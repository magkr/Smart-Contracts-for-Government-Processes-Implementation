import React from "react";
import { getData, saveData } from "../store.js";

export const dataShow = location => {
  var d = "{}"

  getData(1).then(res => console.log(JSON.stringify(res)));
  console.log(d);
  return (
    <div>
      <p>Data her</p>
    </div>
  );
};

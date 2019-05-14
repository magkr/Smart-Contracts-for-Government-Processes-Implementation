const axios = require("axios");

export async function saveData(action, caseID, value, hash, location) {
  var data = {
    action: action,
    caseID: caseID,
    value: value,
    hash: hash,
    location: location
  };

  try {
    var response = await axios({
      method: "PUT",
      url: `http://localhost:8888/`,
      headers: { "Content-Type": "application/json" },
      data
    });
    return response;
  } catch (error) {
    console.log(
      `Save data error [case: ${caseID} - location: ${
        data.location
      }] : ${error}`
    );
  }
}

export async function getData(caseID, id) {
  try {
    var res = await axios.get(`http://localhost:8888/data/${caseID}/${id}`);
    return res.data;
  } catch (error) {
    console.log(
      `Get data error [case: ${caseID} - location: ${id}] : ${error}`
    );
    return null;
  }
}

export async function zip(casenumber) {
  console.log("getting data");
  try {
    window.open(`http://localhost:8888/case/${casenumber}`);
  } catch (error) {
    console.log(`Get case error [case: ${casenumber}]`);
    return null;
  }
}

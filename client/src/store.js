const axios = require("axios");

// var i = 0;
//
// (async function() {
//     let i = axios.get(`http://localhost:8888/nextIdx`);
//
//     console.log("result", i);
// })();


  // async getIdx() {
  //   return axios.get(`http://localhost:8888/nextIdx`);
  // }
  //
  // async saveDataWithID(data) {
  //     this.getIdx().then(async id => {
  //       await axios({
  //           method: "PUT",
  //           url: `http://localhost:8888/${id}`,
  //           headers: { 'Content-Type': 'application/json' },
  //           data: {
  //             id: id,
  //             data: data
  //           }
  //       });
  //       return id;
  //     }).then(async (id) => {
  //       await axios({
  //           method: "PUT",
  //           url: `http://localhost:8888/nextIdx`,
  //           headers: { 'Content-Type': 'application/json' },
  //           data: {
  //             idx: id+1,
  //           }
  //       });
  //       return id
  //     }).then(id => {
  //       return id;
  //     });
  // }

  export async function saveData(action, caseID, value, hash, location) {
    var data = {
      action: action,
      caseID: caseID,
      value: value,
      hash: hash,
      location: location
    };
    return await axios({
      method: "PUT",
      url: `http://localhost:8888/${data.id}`,
      headers: { "Content-Type": "application/json" },
      data
    });
  }

  export async function getData(id) {
    try {
      return await axios.get(`http://localhost:8888/${id}`);
      // console.log(`Get data [id: ${id}]`);
    } catch (error) {
      console.error(`Get data error [hash: ${id}] : ${id}`);
    }
  }

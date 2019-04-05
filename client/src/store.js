const axios = require("axios");

// var i = 0;
//
// (async function() {
//     let i = axios.get(`http://localhost:8888/nextIdx`);
//
//     console.log("result", i);
// })();

class Store {
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

  async saveData(action, caseID, value, hash, id) {
    var data = {
      action: action,
      caseID: caseID,
      value: value,
      hash: hash,
      id: id
    };
    return axios({
      method: "PUT",
      url: `http://localhost:8888/${data.id}`,
      headers: { "Content-Type": "application/json" },
      data
    });
  }

  async getData(id) {
    try {
      return axios.get(`http://localhost:8888/${id}`);
      // console.log(`Get data [id: ${id}]`);
    } catch (error) {
      console.error(`Get data error [hash: ${id}] : ${id}`);
    }
  }
}

export default Store;

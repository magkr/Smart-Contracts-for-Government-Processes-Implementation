const storagepath = ".data";
const app = require("./app");
const kvfs = require("kvfs")(storagepath);

app(kvfs, storagepath).listen(8888);

// var INDEXFILENAME = "nextIdx";
// var indexObject = { idx: 0 };
//
// (async function() {
//   try {
//     const res = await getIndexFile();
//     console.log("nextIdx file exist. Next idx: " + res.data.idx);
//   } catch (error) {
//     await createIdx()
//     .then(() => { console.log("created new nextIdx file"); })
//     .catch(error => { console.log("error creating new index file"); return error; })
//   }
// })();
//
// async function createIdx() {
//     let result = await axios({
//         method: "PUT",
//         url: `http://localhost:8888/${INDEXFILENAME}`,
//         headers: { 'Content-Type': 'application/json' },
//         data: indexObject
//     });
//     return result;
// }
//
// async function getIndexFile() {
//   const res = await axios.get(`http://localhost:8888/${INDEXFILENAME}`);
//   return res;
// }

const express = require("express");
const bodyParser = require("body-parser");
var cors = require("cors");
var zipper = require("zip-a-folder");

module.exports = (kvfs, storagepath) => {
  let app = express();

  app.use(cors());
  app.use(bodyParser.json());

  app.put("", (req, res) => {
    console.log("PUT DATA " + JSON.stringify(req.body));
    if (!req.body || typeof req.body !== "object") {
      return res
        .status(400)
        .send({ error: "Invalid request! I need a body..." });
    }
    kvfs.set(req.body.caseID + "/" + req.body.location, req.body, error => {
      if (error) {
        return res.status(500).send({ error: "Failed to save data" });
      }
      res.send({});
    });
  });

  app.get("/data/:caseid/:id", (req, res) => {
    console.log(
      "GET DATA " + JSON.stringify(req.params) + " " + JSON.stringify(req.body)
    );
    kvfs.get(req.params.caseid + "/" + req.params.id, (error, value) => {
      if (error && error.code == "ENOENT") {
        return res.status(404).send({ error: "invalid ids" }); // id does not exist
      }
      if (error) {
        return res.status(500).send({ error: "Failed to get data" });
      }
      console.log(value);
      res.send(value);
    });
  });

  app.get("/case/:cid", async (req, res) => {
    console.log(
      "GET CASE " + JSON.stringify(req.params) + " " + JSON.stringify(req.body)
    );
    (async function() {
      await zipper.zip(`${storagepath}/${req.params.cid}`, "./_data.zip");
      res.download("./_data.zip");
    })();
  });

  return app;
};

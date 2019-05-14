const storagepath = ".data";
const app = require("./app");
const kvfs = require("kvfs")(storagepath);

app(kvfs, storagepath).listen(8888);

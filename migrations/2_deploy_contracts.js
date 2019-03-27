var AppealsBoard = artifacts.require("./AppealsBoard.sol");
var Process42 = artifacts.require("./Process42.sol");

module.exports = function(deployer) {
  deployer.deploy(Process42);
};

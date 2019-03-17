var Process = artifacts.require("./Process.sol");
var AppealsBoard = artifacts.require("./AppealsBoard.sol");
var Process42 = artifacts.require("./Process42.sol");


module.exports = function(deployer) {
  deployer.deploy(Process);
  deployer.link(Process, Process42);
  deployer.deploy(AppealsBoard);
  deployer.deploy(Process42);
};

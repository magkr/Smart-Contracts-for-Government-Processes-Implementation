var SimpleStorage = artifacts.require("./SimpleStorage.sol");
var Process = artifacts.require("./Process.sol");
var Graph = artifacts.require("./Graph.sol");

module.exports = function(deployer) {
  deployer.deploy(Graph);
  deployer.link(Graph, Process);
  deployer.deploy(Process);
};

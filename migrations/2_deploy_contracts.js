var Process = artifacts.require("./Process.sol");
var Graph = artifacts.require("./Graph.sol");
var ProcessFactory = artifacts.require("./ProcessFactory.sol");


module.exports = function(deployer) {
  deployer.deploy(Graph);
  deployer.link(Graph, Process);
  deployer.link(Graph, ProcessFactory);
  deployer.deploy(ProcessFactory);
  deployer.link(ProcessFactory, Process);
  deployer.deploy(Process);
};

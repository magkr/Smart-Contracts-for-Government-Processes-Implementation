var Process = artifacts.require("./Process.sol");
var IterableMap = artifacts.require("./IterableMap.sol");
var Graph = artifacts.require("./Graph.sol");
var ProcessFactory = artifacts.require("./ProcessFactory.sol");
var AppealsBoard = artifacts.require("./AppealsBoard.sol");

module.exports = function(deployer) {
  deployer.deploy(IterableMap);
  deployer.link(IterableMap, Graph);
  deployer.deploy(Graph);
  deployer.link(Graph, Process);
  deployer.link(Graph, ProcessFactory);
  deployer.deploy(ProcessFactory);
  deployer.link(ProcessFactory, Process);
  deployer.deploy(Process);
  deployer.deploy(AppealsBoard);
};

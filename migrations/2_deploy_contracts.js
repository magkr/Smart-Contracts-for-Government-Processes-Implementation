var SimpleStorage = artifacts.require("./SimpleStorage.sol");
var Process = artifacts.require("./Process.sol");
var Metering = artifacts.require("./Metering.sol");

module.exports = function(deployer) {
  deployer.deploy(SimpleStorage);
  deployer.deploy(Process);
  deployer.deploy(Metering);
};

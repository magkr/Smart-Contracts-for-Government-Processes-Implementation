const Metering = artifacts.require("./Metering.sol");

contract("Metering", accounts => {
  it("...should initialize with correct values", async () => {
    const instance = await Metering.deployed()

    const root = await instance.datas(web3.utils.utf8ToHex("root"));
  });
});

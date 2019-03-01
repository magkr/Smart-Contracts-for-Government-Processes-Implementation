const Process = artifacts.require("./Process.sol");

contract("Process", accounts => {
  it("...should store root", async () => {
    const instance = await Process.deployed();

    const arr = await instance.test.call();
    // arr.forEach((r) => {console.log(web3.utils.hexToUtf8(r));});
    arr.forEach((r) => {console.log(web3.utils.hexToUtf8(r));});


    assert.equal("hej", "root");
  });

  // it("...should store root", async () => {
  //   const instance = await Process.deployed();
  //
  //   const root = await instance.datas(web3.utils.utf8ToHex("root"));
  //
  //   assert.equal(web3.utils.hexToUtf8(root.title), "root");
  // });
  //
  // it("...should have root done as true", async () => {
  //   const instance = await Process.deployed();
  //
  //   const root = await instance.datas(web3.utils.utf8ToHex("root"));
  //
  //   assert.equal(root.done, true);
  // });

  // it("...can not change root.done to false from outside", async () => {
  //   const instance = await Process.deployed();
  //
  //   const root = await instance.datas(web3.utils.utf8ToHex("root"));
  //
  //   root.done = false;
  //
  //   const root1 = await instance.datas(web3.utils.utf8ToHex("root"));
  //
  //   assert.equal(root1.done, true, "data 0 should be equal to root");
  // });
});

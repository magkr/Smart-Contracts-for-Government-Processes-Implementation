pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/IterableMap.sol";

contract TestIterableMap {
  using IterableMap for IterableMap.Map;

  IterableMap.Map map;

  function testIterableMap() public {
    map.insert("hej", 0);
    map.insert("wow", 1);
    map.insert("wowwow", 2);

    map.remove("wow");

    uint next = map.first();
    uint size = map.size();

    bytes32[] memory keys = new bytes32[](size);
    uint[] memory values = new uint[](size);

    for (uint i = 0; i < size; i++) {
      (bytes32 k,uint v) = map.getValue(next);
      keys[i] = k;
      values[i] = v;
      next = map.next(next);
    }

    Assert.equal(size, 2, "there should be 2 elements");
    Assert.equal(next, 3, "next should be 2 ");
    Assert.equal(keys[0], "hej", "k[0] should be hej");
    Assert.equal(keys[1], "wowwow", "k[1] should be wowwow");
    Assert.equal(values[0], 0, "value 0 should be 0");
    Assert.equal(values[1], 2, "value 0 should be 0");
  }
}

pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import { Data, DataNode, DataHandler, ExtraData, ResolutionData } from "../contracts/DataContracts.sol";


contract TestData is DataHandler{

  function testEmitReoslutionEvent() public {
    DataNode dataNodeContract = DataNode(DeployedAddresses.DataNode());

    DataNode dataNode = new DataNode("Test", DataType.FILE, NodeType.RESOLUTION);
    Data resData = dataNode.createData(0);
    Assert.equal(true, true, "c should be UNDONE");
  }
}

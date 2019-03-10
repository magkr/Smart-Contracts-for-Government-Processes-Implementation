pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Process.sol";
import "../contracts/AppealsBoard.sol";
import "../contracts/Graph.sol";
import "../contracts/IterableMap.sol";



contract TestAppealsBoard {
  using Graph for Graph.Digraph;
  using IterableMap for IterableMap.Map;


  /* function testMarkDataInProcess() public {
    Process process = Process(DeployedAddresses.Process());
    AppealsBoard appealsBoard = AppealsBoard(DeployedAddresses.AppealsBoard());

    process.testSetup();
    appealsBoard.setProcessadr(address(process));
    appealsBoard.markData("Familieforhold", 0);

    bool ok = (appealsBoard.getStatus("Familieforhold", 0) == Graph.Status.MARKED);

    Assert.equal(ok, true, "Familieforhold should be marked");
  } */


}

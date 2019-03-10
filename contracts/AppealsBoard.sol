pragma solidity ^0.5.0;

import {Graph} from "./Graph.sol";

contract ProcessInterface {
  function mark(bytes32 title, uint caseID) public;
  function getStatus(bytes32 title, uint caseID) public returns (Graph.Status status);
}

contract AppealsBoard {

  address public processadr;
  ProcessInterface processContract = ProcessInterface(processadr);

  function markData(bytes32 data, uint caseID) public {
    processContract.mark(data, caseID);
  }

  function setProcessadr(address process) public {
    processadr = process;
    processContract = ProcessInterface(processadr);
  }

  function getStatus(bytes32 title, uint caseID) public returns (Graph.Status status) {
    return processContract.getStatus(title, caseID);
  }


}

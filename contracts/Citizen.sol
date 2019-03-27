pragma solidity 0.5.0;

import { DataHandler } from './DataHandler.sol';

contract ProcessInterface {
  function getCase(uint caseID) public;
}

contract Citizen is DataHandler {

  address public processadr;
  ProcessInterface processContract = ProcessInterface(processadr);

  function setProcessadr(address process) public {
    processadr = process;
    processContract = ProcessInterface(processadr);
  }

  function getCase(uint caseID) public {
    processContract.getCase(caseID);
  }

}

pragma solidity 0.5.0;

import {CaseHandler} from "./CaseHandler.sol";

contract TransferHandler is CaseHandler {
  event Transfer(bool success, uint amount, uint32 caseID, address receiver);

  function _sendEther(uint _amount, uint32 _caseID) internal {
    address payable to = address(uint160(caseToAddress[_caseID]));
    bool success = to.send(_amount);
    emit Transfer(success, _amount, _caseID, caseToAddress[_caseID]);
  }
}

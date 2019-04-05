pragma solidity 0.5.0;

import {CaseHandler} from "./CaseHandler.sol";

contract TransferHandler is CaseHandler {

  event Transfer(bool success, uint amount, uint32 caseID, address receiver);

  function _sendEther(uint _amount, uint32 _caseID) internal onlyOwner {
    require(cases[_caseID].status == CaseStatus.READYFORPAYMENT);
    address payable to = address(uint160(caseToAddress[_caseID]));
    bool success = to.send(_amount);
    emit Transfer(success, _amount, _caseID, caseToAddress[_caseID]);
    if(success) {
      cases[_caseID].status = CaseStatus.RESOLVED;
      _cascade(_getIdx(resolvingResolution), cases[_caseID], Status.DONE, Status.UNDONE);
    }
  }
}

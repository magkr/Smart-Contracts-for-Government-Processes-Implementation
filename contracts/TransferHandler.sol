pragma solidity 0.5.0;

import {DataHandler} from "./DataHandler.sol";

contract TransferHandler is DataHandler {

  event Transfer(bool success, uint amount, uint32 caseID, address receiver);

  function _sendEther(uint32 _caseID) internal {
    require(cases[_caseID].status == CaseStatus.READYFORPAYMENT);
    address payable to = address(uint160(caseToAddress[_caseID]));
    bool success = to.send(msg.value);
    emit Transfer(success, msg.value, _caseID, caseToAddress[_caseID]);
    if(success) {
      cases[_caseID].status = CaseStatus.ACTIVE;
      _cascade(_getIdx(resolvingResolution), cases[_caseID], Status.DONE, Status.UNDONE);
    }
  }
}

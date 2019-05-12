pragma solidity 0.5.0;

import {DataHandler} from "./DataHandler.sol";

contract TransferHandler is DataHandler {

  event Transfer(uint amount, uint32 indexed caseID, address receiver, uint date);

  function _sendEther(uint32 _caseID) internal {
    address payable to = address(uint160(caseToAddress[_caseID]));
    to.transfer(msg.value);
    emit Transfer(msg.value, _caseID, caseToAddress[_caseID], block.timestamp);
    _cascadeClear(_getIdx(paymentGate), cases[_caseID]);
  }

  function _cascadeClear(uint v, Case storage c) internal {
    for (uint i = 0; i < adj[v].length; i++) {
      uint a = adj[v][i];
      if (c.dataMapping[activities[a].title].status == Status.DONE) {
        c.dataMapping[activities[a].title] = Data(0, c.id, 0, Status.UNDONE);
        _cascadeClear(a, c);
      }
    }
  }
}

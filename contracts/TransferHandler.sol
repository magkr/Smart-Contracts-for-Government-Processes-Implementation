pragma solidity 0.5.0;

import {DataHandler} from "./DataHandler.sol";

contract TransferHandler is DataHandler {

  event Transfer(bool success, uint amount, uint32 caseID, address receiver, uint date);

  function _sendEther(uint32 _caseID) internal {
    address payable to = address(uint160(caseToAddress[_caseID]));
    bool success = to.send(msg.value);
    emit Transfer(success, msg.value, _caseID, caseToAddress[_caseID], block.timestamp);
    if(success) {
      _cascadeClear(_getIdx(resolvingResolution), cases[_caseID]);
    }
  }

  function _cascadeClear(uint v, Case storage c) internal {
    for (uint i = 0; i < adj[v].length; i++) {
      uint a = adj[v][i];
      if (c.dataMapping[vxs[a].title].status == Status.DONE) {
        c.dataMapping[vxs[a].title] = Data(vxs[a].title, 0, c.id, 0, Status.UNDONE);
        _cascadeClear(a, c);
      }
    }
  }
}

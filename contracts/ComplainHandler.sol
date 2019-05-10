pragma solidity 0.5.0;

import {CaseHandler} from './CaseHandler.sol';

contract ComplainHandler is CaseHandler {

  mapping (uint32 => Complaint) complaints;

  struct Complaint {
    bytes32 data;
    uint32 caseID;
    bool isMarked;
  }

  function _getComplaint(uint32 _caseID) internal view returns (bytes32, bool){
    Complaint memory complaint = complaints[_caseID];
    return (complaint.data, complaint.isMarked);
  }

  function _stadfast(uint32 _caseID) internal {
    require(cases[_caseID].status == CaseStatus.COUNCIL && !complaints[_caseID].isMarked);
    _cascade(_getIdx(complaints[_caseID].data), cases[_caseID], Status.UNSTABLE, Status.DONE);
    Case storage c = cases[_caseID];
    c.status = CaseStatus.ACTIVE;
   }

  function _homesend(uint32 _caseID) internal {
    require(cases[_caseID].status == CaseStatus.COUNCIL && complaints[_caseID].isMarked);
    Case storage c = cases[_caseID];
    c.status = CaseStatus.COMPLAINT;
  }

  function _markData(bytes32 _title, uint32 _caseID) internal {
    require(cases[_caseID].status == CaseStatus.COUNCIL);
    Case storage c = cases[_caseID];
    c.dataMapping[_title].status = Status.MARKED;
    complaints[_caseID].isMarked = true;
    _cascade(_getIdx(_title), c, Status.DONE, Status.UNSTABLE);
  }

  function _complain(bytes32 _title, uint32 _caseID) internal {
    require(vxs[_getIdx(_title)].nodeType == NodeType.RESOLUTION);
    require(cases[_caseID].status != CaseStatus.COMPLAINT && cases[_caseID].status != CaseStatus.COUNCIL);
    Case storage c = cases[_caseID];
    c.status = CaseStatus.COMPLAINT;
    for(uint i = 0; i < vxs.length; i++) {
      if (vxs[i].phase == vxs[_getIdx(_title)].phase) c.dataMapping[vxs[i].title].status = Status.COMPLAINED;
    }
    _cascade(_getIdx(_title), c, Status.DONE, Status.UNSTABLE);
    complaints[_caseID] = Complaint(_title, _caseID, false);
  }

  function _cascade(uint v, Case storage c, Status from, Status to) internal {
    for (uint i = 0; i < adj[v].length; i++) {
      uint a = adj[v][i];
      if (c.dataMapping[vxs[a].title].status == from) {
        c.dataMapping[vxs[a].title].status = to;
        _cascade(a, c, from, to);
      }
    }
  }

}

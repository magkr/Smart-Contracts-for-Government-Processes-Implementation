pragma solidity 0.5.0;

import {CaseHandler} from './CaseHandler.sol';

contract AppealHandler is CaseHandler {

  mapping (uint32 => Appeal) appeals;

  struct Appeal {
    bytes32 data;
    uint32 caseID;
    bool isMarked;
  }

  function _getAppeal(uint32 _caseID) internal view returns (bytes32, bool){
    Appeal memory appeal = appeals[_caseID];
    return (appeal.data, appeal.isMarked);
  }

  function _ratify(uint32 _caseID) internal {
    require(cases[_caseID].status == CaseStatus.APPEALSBOARD && !appeals[_caseID].isMarked);
    _cascade(_getIdx(appeals[_caseID].data), cases[_caseID], Status.UNSTABLE, Status.DONE);
    Case storage c = cases[_caseID];
    c.status = CaseStatus.ACTIVE;
   }

  function _redo(uint32 _caseID) internal {
    require(cases[_caseID].status == CaseStatus.APPEALSBOARD && appeals[_caseID].isMarked);
    Case storage c = cases[_caseID];
    c.status = CaseStatus.APPEALED;
  }

  function _markData(bytes32 _title, uint32 _caseID) internal {
    require(cases[_caseID].status == CaseStatus.APPEALSBOARD);
    Case storage c = cases[_caseID];
    c.dataMapping[_title].status = Status.MARKED;
    appeals[_caseID].isMarked = true;
    _cascade(_getIdx(_title), c, Status.DONE, Status.UNSTABLE);
  }

  function _appeal(bytes32 _title, uint32 _caseID) internal {
    require(activities[_getIdx(_title)].aType == ActivityType.DECISION);
    require(cases[_caseID].status != CaseStatus.APPEALED && cases[_caseID].status != CaseStatus.APPEALSBOARD);
    Case storage c = cases[_caseID];
    c.status = CaseStatus.APPEALED;
    for(uint i = 0; i < activities.length; i++) {
      if (activities[i].phase == activities[_getIdx(_title)].phase) c.dataMapping[activities[i].title].status = Status.APPEALED;
    }
    _cascade(_getIdx(_title), c, Status.DONE, Status.UNSTABLE);
    appeals[_caseID] = Appeal(_title, _caseID, false);
  }

  function _cascade(uint v, Case storage c, Status from, Status to) internal {
    for (uint i = 0; i < adj[v].length; i++) {
      uint a = adj[v][i];
      if (c.dataMapping[activities[a].title].status == from) {
        c.dataMapping[activities[a].title].status = to;
        _cascade(a, c, from, to);
      }
    }
  }
}

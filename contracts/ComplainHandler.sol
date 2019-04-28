pragma solidity 0.5.0;

import {CaseHandler} from './CaseHandler.sol';

contract ComplainHandler is CaseHandler {

  function _complainFillData(bytes32 _title, uint32 _caseID, bytes32 _dataHash) internal returns (uint id) {
    require(cases[_caseID].status == CaseStatus.COMPLAINT);
    Case storage c = cases[_caseID];
    if(c.dataMapping[_title].dataHash != _dataHash) {
      dataCount++;
      if(complaints[_caseID].data == _title) {
        c.status = CaseStatus.ACTIVE;
        //TODO emit decision;
      }
      c.dataMapping[_title] = Data(_title, _dataHash, _caseID, dataCount, Status.DONE);
      emit NewData(_title,  _dataHash, _caseID, dataCount, uint(vxs[_getIdx(_title)].nodeType));

      return dataCount;
    } else {
      c.dataMapping[_title].status = Status.DONE;
      if(complaints[_caseID].data == _title) {
        c.status = CaseStatus.COUNCIL;
      }
      return c.dataMapping[_title].id;
    }
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


}

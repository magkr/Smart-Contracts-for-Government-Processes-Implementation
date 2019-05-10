pragma solidity 0.5.0;

import {ComplainHandler} from './ComplainHandler.sol';

contract DataHandler is ComplainHandler {

  function _complainFillData(bytes32 _title, uint32 _caseID, bytes32 _dataHash) internal returns (uint32 id) {
    require(cases[_caseID].status == CaseStatus.COMPLAINT);
    Case storage c = cases[_caseID];
    if(c.dataMapping[_title].dataHash != _dataHash) {
      dataCount++;
      if(complaints[_caseID].data == _title) {
        c.status = CaseStatus.ACTIVE;
        //TODO emit decision;
      }
      c.dataMapping[_title] = Data(_dataHash, _caseID, dataCount, Status.DONE);
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

  function _fillData(bytes32 _title, uint32 _caseID, bytes32 _dataHash) internal returns (uint32 id) {
    if(cases[_caseID].status == CaseStatus.ACTIVE) return _activeFillData(_title, _caseID, _dataHash);
    else if(cases[_caseID].status == CaseStatus.COMPLAINT) return _complainFillData(_title, _caseID, _dataHash);
  }

  function _activeFillData(bytes32 _title, uint32 _caseID, bytes32 _dataHash) internal returns (uint32 id) {
    require(cases[_caseID].status == CaseStatus.ACTIVE);
    require(_allowed(_title, cases[_caseID]));
    Case storage c = cases[_caseID];

    dataCount++;
    c.dataMapping[_title] = Data(_dataHash, _caseID, dataCount, Status.DONE);

    emit NewData(_title,  _dataHash, _caseID, dataCount, uint(vxs[_getIdx(_title)].nodeType));
    return dataCount;
  }

}

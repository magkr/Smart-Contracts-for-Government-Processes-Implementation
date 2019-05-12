pragma solidity 0.5.0;

import {AppealHandler} from './AppealHandler.sol';

contract DataHandler is AppealHandler {

  function _appealFillData(bytes32 _title, uint32 _caseID, bytes32 _dataHash) internal returns (uint32 id) {
    require(cases[_caseID].status == CaseStatus.APPEALED);
    Case storage c = cases[_caseID];
    if(c.dataMapping[_title].dataHash != _dataHash) {

      if(appeals[_caseID].data == _title) {
        c.status = CaseStatus.ACTIVE;
      }

      dataCount++;
      c.dataMapping[_title] = Data(_dataHash, _caseID, dataCount, Status.DONE);
      emit NewData(_title,  _dataHash, _caseID, dataCount, uint(activities[_getIdx(_title)].aType));

      return dataCount;
    } else {

      c.dataMapping[_title].status = Status.DONE;
      if(appeals[_caseID].data == _title) {
        c.status = CaseStatus.APPEALSBOARD;
      }

      return c.dataMapping[_title].id;
    }
  }

  function _fillData(bytes32 _title, uint32 _caseID, bytes32 _dataHash) internal returns (uint32 id) {
    if(cases[_caseID].status == CaseStatus.ACTIVE) return _activeFillData(_title, _caseID, _dataHash);
    else if(cases[_caseID].status == CaseStatus.APPEALED) return _appealFillData(_title, _caseID, _dataHash);
  }

  function _activeFillData(bytes32 _title, uint32 _caseID, bytes32 _dataHash) internal returns (uint32 id) {
    require(cases[_caseID].status == CaseStatus.ACTIVE);
    require(_allowed(_title, cases[_caseID]));
    Case storage c = cases[_caseID];

    dataCount++;
    c.dataMapping[_title] = Data(_dataHash, _caseID, dataCount, Status.DONE);

    emit NewData(_title,  _dataHash, _caseID, dataCount, uint(activities[_getIdx(_title)].aType));
    return dataCount;
  }

}

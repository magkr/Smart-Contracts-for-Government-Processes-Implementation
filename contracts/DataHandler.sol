pragma solidity 0.5.0;

import {ComplainHandler} from './ComplainHandler.sol';

contract DataHandler is ComplainHandler {

  function _fillDatas(bytes32[] memory _titles, uint32 _caseID, bytes32[] memory _dataHashes) internal returns (uint[] memory ids) {
    ids = new uint[](_titles.length);
    if(cases[_caseID].status == CaseStatus.ACTIVE) {
      for(uint i = 0; i < _titles.length; i++) {
        ids[i] = _activeFillData(_titles[i], _caseID, _dataHashes[i]);
      }
    }
    else if(cases[_caseID].status == CaseStatus.COMPLAINT) {
      for(uint i = 0; i < _titles.length; i++) {
        ids[i] = _complainFillData(_titles[i], _caseID, _dataHashes[i]);
      }
    }
  }

  function _fillData(bytes32 _title, uint32 _caseID, bytes32 _dataHash) internal returns (uint id) {
    if(cases[_caseID].status == CaseStatus.ACTIVE) return _activeFillData(_title, _caseID, _dataHash);
    else if(cases[_caseID].status == CaseStatus.COMPLAINT) return _complainFillData(_title, _caseID, _dataHash);
  }

  function _activeFillData(bytes32 _title, uint32 _caseID, bytes32 _dataHash) internal returns (uint id) {
    require(cases[_caseID].status == CaseStatus.ACTIVE);
    require(_allowed(_title, cases[_caseID]));
    Case storage c = cases[_caseID];

    dataCount++;
    c.dataMapping[_title] = Data(_title, _dataHash, _caseID, dataCount, Status.DONE);

    emit NewData(_title,  _dataHash, _caseID, dataCount, uint(vxs[_getIdx(_title)].nodeType));
    return dataCount;
  }

  function _markData(bytes32 _title, uint32 _caseID) internal {
    require(cases[_caseID].status == CaseStatus.COUNCIL);
    Case storage c = cases[_caseID];
    c.dataMapping[_title].status = Status.MARKED;
    complaints[_caseID].isMarked = true;
    _cascade(_getIdx(_title), c, Status.DONE, Status.UNSTABLE);
  }

}

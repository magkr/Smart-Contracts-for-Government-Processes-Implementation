pragma solidity 0.5.0;

import {DataHandler} from './DataHandler.sol';

contract CaseHandler is DataHandler {
  enum CaseStatus { ACTIVE, COMPLAINT, OLD }

  struct Case {
  	bytes32[] dataKeyList;
    mapping (bytes32 => Data) dataMapping;
    CaseStatus status;
    //mapping (uint => Data[]) extraDatas;
  }

  Case[] cases;
  mapping (address => uint32) addressToCase;

  function createData(DataNode storage _dataNode, uint32 _caseId) private returns (Data memory) {
    return Data(_dataNode.title, 0, 0, _caseId, _dataNode.dataType, Status.UNDONE);
  }


  function markAsDone(bytes32 title, uint32 caseID) public {
    cases[caseID].dataMapping[title].status = Status.DONE;
  }

  function addCase(address addr) public {
    // if case exist, throw error
    uint32 idx = uint32(cases.length);
    addressToCase[addr] = idx;
    bytes32[] memory datas;
    cases.push(Case(datas, CaseStatus.ACTIVE));
    for(uint i = 0; i < vxs.length; i++){
      cases[idx].dataMapping[vxs[i].title] = createData(vxs[i], idx);
      cases[idx].dataKeyList.push(vxs[i].title);
    }
  }

  function getCases() public view returns (uint[] memory){
    uint[] memory caseIDs = new uint[](cases.length);

    for(uint i = 0; i < cases.length; i++){
      caseIDs[i] = i;
    }
    return caseIDs;
  }

  function getCase(uint caseID) public view returns(bytes32[] memory titles, bytes32[] memory statuss, uint32[] memory locations) {
    /* TODO sikr det kun er SBH der kan spørge */
    titles = new bytes32[](vxs.length);
    statuss = new bytes32[](vxs.length);
    locations = new uint32[](vxs.length);

    bytes32[] memory data = cases[caseID].dataKeyList;
    for(uint i = 0; i < vxs.length; i++){
      titles[i] = data[i];
      statuss[i] = _getStatusString(cases[caseID].dataMapping[data[i]].status);
      locations[i] = cases[caseID].dataMapping[data[i]].dbLocation;
    }
  }

  function getActions(uint caseID) public view returns (bytes32[] memory) {
    /* TODO if case doesnt exist, throw error */
    bytes32[] memory toDo = new bytes32[](vxs.length);
    uint count = 0;

    for (uint v = 0; v < vxs.length; v++) {
      if(_isReady(v, caseID)) {
        toDo[count] = vxs[v].title;
        count++;
      }
    }

    return _cut(toDo, count);
  }

  function _isReady(uint v, uint caseID) private view returns (bool) {
    // if v doesnt exist, throw error
    if (cases[caseID].dataMapping[vxs[v].title].status == Status.DONE) return false;
    for(uint j = 0; j < req[v].length; j++) {
      uint reqIdx = req[v][j];
      if (cases[caseID].dataMapping[cases[caseID].dataKeyList[reqIdx]].status != Status.DONE) return false;
    }

    return true;
  }

  function fillData(bytes32 _title, uint32 _caseID, bytes32 _dataHash, uint32 _dbLocation) public {
    /* TODO TJEK OM DATAHASH ER TOM */
    cases[_caseID].dataMapping[_title].dbLocation = _dbLocation;
    cases[_caseID].dataMapping[_title].dataHash = _dataHash;
    cases[_caseID].dataMapping[_title].status = Status.DONE;

  }

  function markData(bytes32 _title, uint _caseID) public {
    /* TODO EXPLANATION AS PARAMETER */

    cases[_caseID].dataMapping[_title].status = Status.MARKED;
    _cascade(_title, _caseID);
  }

  function _cascade(bytes32 _title, uint caseID) private {
    for (uint i = 0; i < adj[_getIdx(_title)].length; i++) {
      uint adjIdx = adj[_getIdx(_title)][i];
      if (cases[caseID].dataMapping[vxs[adjIdx].title].status == Status.DONE) {
        cases[caseID].dataMapping[vxs[adjIdx].title].status = Status.PENDING;
        _cascade(vxs[adjIdx].title, caseID);
      }
    }
  }


}

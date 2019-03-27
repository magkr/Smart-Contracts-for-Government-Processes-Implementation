pragma solidity 0.5.0;

import  {DataHandler} from './DataHandler.sol';

contract CaseHandler is DataHandler {
  enum CaseStatus { ACTIVE, COMPLAINT, OLD }

  struct Case {
  	Data[] dataList;
    CaseStatus status;
  }

  Case[] cases;
  mapping (address => uint32) addressToCase;

  function createData(DataNode storage _dataNode, uint32 _caseId) private returns (Data memory) {
    return Data(_dataNode.title, 0, 0, _caseId, _dataNode.dataType, Status.UNDONE);
  }

/*
  function markAsDone(bytes32 title, uint caseID) public {
    cases[caseID].dataList[_getIdx(title)].setStatus(Status.DONE);
  }

  function addCase(address addr) public {
    // if case exist, throw error
    uint idx = cases.length;
    addressToCase[addr] = idx;
    cases.push(Case(new Data[](0), CaseStatus.ACTIVE));
    for(uint i = 0; i < vxs.length; i++){
      Data memory d = createData(vxs[i], idx);
      cases[idx].dataList.push(d);
    }
  }

  function getCases() public view returns (uint[] memory){
    uint[] memory caseIDs = new uint[](cases.length);

    for(uint i = 0; i < cases.length; i++){
      caseIDs[i] = i;
    }
    return caseIDs;
  }

  function getCase(uint caseID) public view returns(bytes32[] memory titles, bytes32[] memory statuss, uint[] memory locations) {
    /* TODO sikr det kun er SBH der kan spørge
    titles = new bytes32[](vxs.length);
    statuss = new bytes32[](vxs.length);
    locations = new uint[](vxs.length);

    Data[] memory data = cases[caseID].dataList;
    for(uint i = 0; i < vxs.length; i++){
      titles[i] = vxs[i].getTitle();
      statuss[i] = _getStatusString(data[i].status());
      locations[i] = data[i].dbLocation();
    }
  }

  function _getStatusString(Status status) private pure returns(bytes32) {
    if (status == Status.DONE) return "done";
    if (status == Status.UNDONE) return "undone";
    if (status == Status.PENDING) return "pending";
    if (status == Status.MARKED) return "marked";
    else return "";  /* TODO THROW ERROR !!!
  }

  function getActions(uint caseID) public view returns (bytes32[] memory) {
    /* TODO if case doesnt exist, throw error
    bytes32[] memory toDo = new bytes32[](vxs.length);
    uint count = 0;

    for (uint v = 0; v < vxs.length; v++) {
      if(_isReady(v, caseID)) {
        toDo[count] = vxs[v].getTitle();
        count++;
      }
    }

    return _cut(toDo, count);
  }

  function _isReady(uint v, uint caseID) private view returns (bool) {
    // if v doesnt exist, throw error
    if (cases[caseID].dataList[v].status() == Status.DONE) return false;
    for(uint j = 0; j < req[v].length; j++) {
      uint reqIdx = req[v][j];
      if (cases[caseID].dataList[reqIdx].status() != Status.DONE) return false;
    }

    return true;
  }

  function fillData(bytes32 _title, uint _caseID, bytes32 _dataHash, uint _dbLocation) public {
    /* TODO TJEK OM DATAHASH ER TOM
    cases[_caseID].dataList[_getIdx(_title)].fill(_dbLocation, _dataHash); /* Database location TODO
    cases[_caseID].dataList[_getIdx(_title)].setStatus(Status.DONE);

  }

  function markData(bytes32 _title, uint _caseID) public {
    /* TODO EXPLANATION AS PARAMETER
    uint v = _getIdx(_title);
    cases[_caseID].dataList[v].setStatus(Status.MARKED);
    _cascade(v, _caseID);
  }

  function _cascade(uint v, uint caseID) private {
    for (uint i = 0; i < adj[v].length; i++) {
      uint adjIdx = adj[v][i];
      if (cases[caseID].dataList[adjIdx].status() == Status.DONE) {
        cases[caseID].dataList[adjIdx].setStatus(Status.PENDING);
        _cascade(adjIdx, caseID);
      }
    }
  } */


}

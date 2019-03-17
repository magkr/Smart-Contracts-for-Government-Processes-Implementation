pragma solidity 0.5.0;

import { Data, DataNode, DataHandler } from './Data.sol';

contract Process42 is DataHandler {
  struct Case {
  	Data[] dataList;
  }

  DataNode[] vxs;
  mapping (uint => uint[]) adj;
  mapping (uint => uint[]) req;
  mapping (bytes32 => uint) titleToID;

  Case[] cases;

  function _getIdx(bytes32 title) private view returns (uint id) {
    // if v doesn't exist, throw error
    return titleToID[title]-1;
  }

  function _addVertex(bytes32 _title, DataType _dataType) internal {
    // if title exists, throw error
    vxs.push(new DataNode(_title, _dataType));
    titleToID[_title] = vxs.length;
  }

  function _addEdge(bytes32 from, bytes32 to) internal {
    // if v or w doesn't exist, throw error
    uint v = _getIdx(from);
    uint w = _getIdx(to);

    if (v < 0 || v >= vxs.length || w < 0 || w >= vxs.length) return;

    adj[v].push(w);
    req[w].push(v);
  }

  function markAsDone(bytes32 title, uint caseID) public {
    cases[caseID].dataList[_getIdx(title)].setStatus(Status.DONE);
  }

  function addCase() public {
    // if case exist, throw error
    uint idx = cases.length;
    cases.push(Case(new Data[](0)));
    for(uint i = 0; i < vxs.length; i++){
      Data d = vxs[i].createData(idx);
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

  function getCase(uint caseID) public view returns(bytes32[] memory titles, bytes32[] memory statuss) {
    titles = new bytes32[](vxs.length);
    statuss = new bytes32[](vxs.length);

    Data[] memory data = cases[caseID].dataList;
    for(uint i = 0; i < vxs.length; i++){
      titles[i] = vxs[i].getTitle();
      statuss[i] = _getStatusString(data[i].status());
    }
  }

  function _getStatusString(Status status) private pure returns(bytes32) {
    if (status == Status.DONE) return "done";
    if (status == Status.UNDONE) return "undone";
    if (status == Status.PENDING) return "pending";
    if (status == Status.MARKED) return "marked";
    else return "";  /* TODO THROW ERROR !!! */
  }

  function getActions(uint caseID) public view returns (bytes32[] memory) {
    /* TODO if case doesnt exist, throw error */
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

  function fillData(bytes32 _title, uint _caseID, uint _dataHash) public {
    /* TODO TJEK OM DATAHASH ER TOM */
    cases[_caseID].dataList[_getIdx(_title)].fill(0, _dataHash); /* Database location TODO  */
    cases[_caseID].dataList[_getIdx(_title)].setStatus(Status.DONE);
  }

  function markData(bytes32 _title, uint _caseID) public {
    /* TODO EXPLANATION AS PARAMETER */
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
  }

  function _cut(bytes32[] memory arr, uint count) private pure returns (bytes32[] memory) {
    bytes32[] memory res = new bytes32[](count);
    for (uint i = 0; i < count; i++) { res[i] = arr[i]; }
    return res;
  }
}

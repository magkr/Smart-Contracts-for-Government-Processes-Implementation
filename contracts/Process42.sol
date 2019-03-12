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

  function getActions(uint caseID) public view returns (bytes32[] memory) {
    // if case doesnt exist, throw error
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
    for(uint j = 0; j < req[v].length; j++) {
      uint reqIdx = req[v][j];
      if (cases[caseID].dataList[reqIdx].status() != Status.DONE) return false;
    }

    return true;
  }

  function fillData(bytes32 _title, uint _caseID, uint _dataHash) public {
    
    cases[_caseID].dataList[_getIdx(_title)].fill(_dataHash);
    cases[_caseID].dataList[_getIdx(_title)].setStatus(Status.DONE);
  }

  function _cut(bytes32[] memory arr, uint count) private pure returns (bytes32[] memory) {
    bytes32[] memory res = new bytes32[](count);
    for (uint i = 0; i < count; i++) { res[i] = arr[i]; }
    return res;
  }
}

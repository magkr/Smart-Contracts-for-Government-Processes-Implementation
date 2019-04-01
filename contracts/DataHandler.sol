pragma solidity 0.5.0;

import {CaseHandler} from './CaseHandler.sol';

contract Graph is CaseHandler {
  /* enum DataType { INT, TEXT, FILE, BOOL } */
  enum NodeType { EXTRA, RESOLUTION, NORMAL }

  /* event Resolution(Data data); */

  struct DataNode {
    /* DataType dataType; */
    /* NodeType nodeType; */
    bytes32 title;
    bool resolution;
  }

  DataNode[] vxs;
  mapping (uint => uint[]) adj;
  mapping (uint => uint[]) req;
  mapping (bytes32 => uint) titleToID;


  function _getIdx(bytes32 title) internal view returns (uint id) {
    // if v doesn't exist, throw error
    return titleToID[title]-1;
  }

  function _addVertex(bytes32 _title, bool _resolution) internal {
    // if title exists, throw error
    vxs.push(DataNode(_title, _resolution));
    titleToID[_title] = vxs.length;
  }

  function _addEdge(bytes32 from, bytes32 to) public {
    // if v or w doesn't exist, throw error
    uint v = _getIdx(from);
    uint w = _getIdx(to);

    if (v < 0 || v >= vxs.length || w < 0 || w >= vxs.length) return;

    adj[v].push(w);
    req[w].push(v);
  }


  function getActions(uint caseID) public view returns (bytes32[] memory) {
    require(caseID >= 0 && caseID <= cases.length);
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
      if (cases[caseID].dataMapping[vxs[reqIdx].title].status != Status.DONE) return false;
    }

    return true;
  }

  function createData(DataNode storage _dataNode, uint32 _caseId) private view returns (Data memory) {
    return Data(_dataNode.title, 0, 0, _caseId, Status.UNDONE);
  }

  function fillData(bytes32 _title, uint32 _caseID, bytes32 _dataHash, uint32 _dbLocation) public {
    /* TODO TJEK OM DATAHASH ER TOM */
    cases[_caseID].dataMapping[_title].dbLocation = _dbLocation;
    cases[_caseID].dataMapping[_title].dataHash = _dataHash;
    cases[_caseID].dataMapping[_title].status = Status.DONE;
  }

  /* function markData(bytes32 _title, uint _caseID) public {
    /* TODO EXPLANATION AS PARAMETER 

    cases[_caseID].dataMapping[_title].status = Status.MARKED;
    _cascade(_title, _caseID);
  } */

  /* function markAsDone(bytes32 title, uint32 caseID) public {
    cases[caseID].dataMapping[title].status = Status.DONE;
  } */

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

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
      if(_isReady(v, cases[caseID])) {
        toDo[count] = vxs[v].title;
        count++;
      }
    }

    return _cut(toDo, count);
  }

  function _isReady(uint v, Case storage c) private view returns (bool) {
    // if v doesnt exist, throw error
    if (data[c.titleToID[vxs[v].title]].status == Status.DONE) return false;
    for(uint j = 0; j < req[v].length; j++) {
      uint reqIdx = req[v][j];
      if (data[c.titleToID[vxs[reqIdx].title]].status != Status.DONE) return false;
    }

    return true;
  }

  function markData(uint32 dataID) public onlyOwnerOf(data[dataID].caseID)  {
    /* TODO EXPLANATION AS PARAMETER */

    data[dataID].status = Status.MARKED;
    _cascade(data[dataID].name, cases[data[dataID].caseID]);
  }

  function _cascade(bytes32 _title, Case storage c) private {
    for (uint i = 0; i < adj[_getIdx(_title)].length; i++) {
      uint adjIdx = adj[_getIdx(_title)][i];
      if (data[c.titleToID[vxs[adjIdx].title]].status == Status.DONE) {
        data[c.titleToID[vxs[adjIdx].title]].status = Status.PENDING;
        _cascade(vxs[adjIdx].title, c);
      }
    }
  }
}

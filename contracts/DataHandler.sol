pragma solidity 0.5.0;

contract Graph {
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
}
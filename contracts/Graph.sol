pragma solidity 0.5.0;


contract Graph {
  /* enum DataType { INT, TEXT, FILE, BOOL } */
  enum NodeType { NORMAL, RESOLUTION, DOC, PAYMENT }
  bytes32 resolvingResolution;
  bytes32 root = "root";
  bytes32 end = "end";


  struct DataNode {
    /* DataType dataType; */
    bytes32 title;
    bytes32 phase;
    bool resolution;
    NodeType nodeType;
  }

  DataNode[] vxs;
  mapping (uint => uint[]) adj;
  mapping (uint => uint[]) req;
  mapping (bytes32 => uint) titleToID;

  function _getIdx(bytes32 title) internal view returns (uint id) {
    // if v doesn't exist, throw error
    return titleToID[title]-1;
  }

  function _addVertex(bytes32 _title, bytes32 _phase, bool _resolution, NodeType _type) internal {
    // if title exists, throw error
    vxs.push(DataNode(_title, _phase, _resolution, _type));
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



}

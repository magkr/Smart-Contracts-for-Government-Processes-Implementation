pragma solidity 0.5.0;

contract DataHandler {
  enum DataType { INT, TEXT, FILE, BOOL }
  enum Status { DONE, UNDONE, MARKED, PENDING }
  enum NodeType { EXTRA, RESOLUTION, NORMAL }

  /* event Resolution(Data data); */

  struct DataNode {
    DataType dataType;
    NodeType nodeType;
    bytes32 title;
    bool resolution;
  }

  struct Data {
    bytes32 instanceOf;
    bytes32 dataHash;
    uint32 dbLocation;
    uint32 caseID;
    DataType dataType;
    Status status;
  }

  DataNode[] vxs;
  mapping (uint => uint[]) adj;
  mapping (uint => uint[]) req;
  mapping (bytes32 => uint) titleToID;

  function _getIdx(bytes32 title) internal view returns (uint id) {
    // if v doesn't exist, throw error
    return titleToID[title]-1;
  }

  function _addVertex(bytes32 _title, DataType _dataType, NodeType _nodeType, bool _resolution) internal {
    // if title exists, throw error
    vxs.push(DataNode(_dataType, _nodeType, _title, _resolution));
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

  function _cut(bytes32[] memory arr, uint count) internal pure returns (bytes32[] memory) {
    bytes32[] memory res = new bytes32[](count);
    for (uint i = 0; i < count; i++) { res[i] = arr[i]; }
    return res;
  }

  function _getStatusString(Status status) internal pure returns(bytes32) {
    if (status == Status.DONE) return "done";
    if (status == Status.UNDONE) return "undone";
    if (status == Status.PENDING) return "pending";
    if (status == Status.MARKED) return "marked";
    else return "";  /* TODO THROW ERROR !!! */
  }


}

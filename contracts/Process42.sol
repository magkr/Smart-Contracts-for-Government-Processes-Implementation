pragma solidity 0.5.0;

contract DataHandler {
  enum DataType { INT, TEXT, FILE, BOOL }
  enum Status { DONE, UNDONE, MARKED, PENDING }
}

contract DataNode is DataHandler {
  bytes32 title;
  DataType dataType;

  constructor(bytes32 _title, DataType _dataType) public {
    title = _title;
    dataType = _dataType;
  }

  function createData(uint _caseID) public returns (Data) {
    return new Data(title, dataType, _caseID);
  }

  function getTitle() public view returns (bytes32) {
    return title;
  }
}

contract Data is DataHandler {
  bytes32 instanceOf;
  DataType dataType;
  Status public status;
  uint dataHash;
  uint caseID;

  constructor(bytes32 _instanceOf, DataType _dataType, uint _caseID) public {
    instanceOf = _instanceOf;
    dataType = _dataType;
    caseID = _caseID;
    status = Status.UNDONE;
  }

  function fill(uint _dataHash) public {
    dataHash = _dataHash;
  }

  function setStatus(Status _status) public {
    status = _status;
  }
}

contract DataSpecial is Data {
  Data[] extraData;
  mapping (bytes32 => uint) dataID;

  constructor(bytes32 _instanceOf, uint _caseID) Data(_instanceOf, DataType.BOOL, _caseID) public {
    extraData = new Data[](0);
  }

  function add(bytes32 title, DataType dataType) public {
    Data d = new Data(title, dataType, caseID);
    extraData.push(d);
    dataID[title] = extraData.length;
  }

  function fill(uint _isExtraNeeded) public {
    require(_isExtraNeeded == 0 || _isExtraNeeded == 1);
    if (_isExtraNeeded == 0) setStatus(Status.DONE);
    if (_isExtraNeeded == 1) setStatus(Status.UNDONE);
    else {} // throw error
    dataHash = _isExtraNeeded;
  }

  function fillExtra(bytes32 title, uint _dataHash) public returns (bool){
    if (dataID[title] == 0) { return false; }
    uint index = dataID[title] - 1;
    extraData[index].fill(_dataHash);
    return true;
  }

  function setStatus(Status _status) public {
    // to be implemented
    status = _status;
  }
}

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

  function _addVertex(bytes32 _title, DataType _dataType) private {
    // if title exists, throw error
    vxs.push(new DataNode(_title, _dataType));
    titleToID[_title] = vxs.length;
  }

  function _addEdge(bytes32 from, bytes32 to) private {
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

    return cut(toDo, count);
  }

  function _isReady(uint v, uint caseID) private view returns (bool) {
    // if v doesnt exist, throw error
    for(uint j = 0; j < req[v].length; j++) {
      uint reqIdx = req[v][j];
      if (cases[caseID].dataList[reqIdx].status() != Status.DONE) return false;
    }

    return true;
  }

  function cut(bytes32[] memory arr, uint count) public pure returns (bytes32[] memory) {
    bytes32[] memory res = new bytes32[](count);
    for (uint i = 0; i < count; i++) { res[i] = arr[i]; }
    return res;
  }
}

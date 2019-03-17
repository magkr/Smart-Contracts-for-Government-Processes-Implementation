pragma solidity 0.5.0;

contract DataHandler {
  enum DataType { INT, TEXT, FILE, BOOL }
  enum Status { DONE, UNDONE, MARKED, PENDING }
  enum NodeType { EXTRA, RESOLUTION, NORMAL }
  /* event Resolution(Data data); */
}

contract DataNode is DataHandler {
  bytes32 title;
  DataType dataType;
  NodeType nodeType;

  constructor(bytes32 _title, DataType _dataType, NodeType _nodeType) public {
    title = _title;
    dataType = _dataType;
    nodeType = _nodeType;
  }

  function createData(uint _caseID) public returns (Data) {
    /* if(nodeType == NodeType.EXTRA) return new ExtraData(title, _caseID); */
    if(nodeType == NodeType.RESOLUTION) return new ResolutionData(title, dataType, _caseID);
    else return new Data(title, dataType, _caseID);
  }

  function getTitle() public view returns (bytes32) {
    return title;
  }
}

contract Data is DataHandler {
  bytes32 instanceOf;
  DataType dataType;
  Status public status;
  uint dbLocation;
  uint dataHash;
  uint caseID;

  constructor(bytes32 _instanceOf, DataType _dataType, uint _caseID) public {
    instanceOf = _instanceOf;
    dataType = _dataType;
    caseID = _caseID;
    status = Status.UNDONE;
  }

  function fill(uint _dbLocation, uint _dataHash) public {
    dbLocation = _dbLocation;
    dataHash = _dataHash;
  }

  function setStatus(Status _status) public {
    status = _status;
  }
}

contract ExtraData is Data {
  Data[] extras;
  mapping (bytes32 => uint) dataID;

  constructor(bytes32 _instanceOf, uint _caseID) Data(_instanceOf, DataType.BOOL, _caseID) public {
    extras = new Data[](0);
  }

  function add(bytes32 title, DataType dataType) public {
    Data d = new Data(title, dataType, caseID);
    extras.push(d);
    dataID[title] = extras.length;
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
    extras[index].fill(0, _dataHash); /* Database location TODO  */
    return true;
  }

  function setStatus(Status _status) public {
    // to be implemented
    status = _status;
  }
}

contract ResolutionData is Data {

  constructor(bytes32 _instanceOf, DataType _dataType, uint _caseID) Data(_instanceOf, _dataType, _caseID) public {

  }

  function fill(uint _dbLocation, uint _dataHash) public {
    dbLocation = _dbLocation;
    dataHash = _dataHash;
    /* emit Resolution(this); */
  }
}

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
    extraData[index].fill(0, _dataHash); /* Database location TODO  */
    return true;
  }

  function setStatus(Status _status) public {
    // to be implemented
    status = _status;
  }
}

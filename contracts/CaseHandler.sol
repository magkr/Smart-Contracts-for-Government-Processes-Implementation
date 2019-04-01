pragma solidity 0.5.0;

import {Ownable} from './Ownable.sol';

contract CaseHandler is Ownable {
  Case[] public cases;
  Data[] public data;
  mapping (uint32 => address) caseToAddress;
  mapping (address => uint32) caseCount;  // TODO INCREMENT THIS

  struct Case {
    CaseStatus status;
    uint32[] datas;
    mapping (bytes32 => uint32) titleToID;
    //mapping (uint => Data[]) extraDatas;
  }

  struct Data {
    bytes32 name;
    bytes32 dataHash;
    uint32 dbLocation;
    uint32 caseID;
    uint32 id;
    /* DataType dataType; */
    Status status;
  }

  /* event Resolution(Data data); */
  enum CaseStatus { ACTIVE, COMPLAINT, OLD }
  enum Status { UNDONE, DONE, MARKED, PENDING }


  modifier onlyOwnerOf(uint32 _caseID) {
    require(isOwner() || caseToAddress[_caseID] == msg.sender);
    _;
  }


  function addCase(address user) external onlyOwner {
    // if case exist, throw error
    uint32 idx = uint32(cases.push(Case(CaseStatus.ACTIVE, new uint32[](0)))-1);
    caseToAddress[idx] = user;
    caseCount[user]++;
  }

  function casesLength() public view onlyOwner returns (uint) {
    return cases.length;
  }

  function getCases(address user) public view returns (uint32[] memory) {
    require(isOwner() || msg.sender == user);
    uint32[] memory res = new uint32[](caseCount[user]);
    uint32 counter = 0;

    for(uint32 i = 0; i < caseCount[user]; i++){
      if (caseToAddress[i] == user){
        res[counter] = i;
        counter++;
      }
    }
    return res;
  }


  function fillData(bytes32 _title, uint32 _caseID, bytes32 _dataHash, uint32 _dbLocation) public onlyOwner {
     /* TODO require at dataHash ikke er tom? */
    require(_caseID >= 0 && _caseID <= cases.length);
    uint32 idx = uint32(data.length);
    data.push(Data(_title, _dataHash, _dbLocation, _caseID, idx, Status.DONE));
    cases[_caseID].datas.push(idx);
    cases[_caseID].titleToID[_title] = idx;
  }

  function update(uint32 dataID, bytes32 _dataHash, uint32 _dbLocation) public onlyOwnerOf(data[dataID].caseID) {
    /* TODO require at dataHash ikke er tom? */
    data[dataID].dbLocation = _dbLocation;
    data[dataID].dataHash = _dataHash;
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

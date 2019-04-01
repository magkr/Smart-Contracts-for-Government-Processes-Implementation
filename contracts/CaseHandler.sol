pragma solidity 0.5.0;

import {Ownable} from './Ownable.sol';

contract CaseHandler is Ownable {
  Case[] public cases;
  Data[] public data;
  mapping (uint32 => address) caseToAddress;
  mapping (address => uint32) caseCount;  // TODO INCREMENT THIS

  struct Case {
    CaseStatus status;
    mapping(bytes32 => Data) dataMapping;
    uint32 id;
    //mapping (uint => Data[]) extraDatas;
  }

  struct Data {
    bytes32 name;
    bytes32 dataHash;
    uint32 dbLocation;
    uint32 caseID;
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
    uint32 idx = uint32(cases.length);
    cases.push(Case(CaseStatus.ACTIVE, idx));
    caseToAddress[idx] = user;
    caseCount[user]++;
  }

  function casesLength() public view onlyOwner returns (uint) {
    return cases.length;
  }

  function getCases(address _owner) public view returns (uint32[] memory) {
    require(isOwner() || msg.sender == _owner);
    uint32[] memory res = new uint32[](caseCount[_owner]);
    uint32 counter = 0;

    for(uint32 i = 0; i < caseCount[_owner]; i++){
      if (caseToAddress[i] == _owner){
        res[counter] = i;
        counter++;
      }
    }
    return res;
  }

  function addressFromCase(uint32 caseID) public view onlyOwnerOf(caseID) returns(address) {
    return caseToAddress[caseID];
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

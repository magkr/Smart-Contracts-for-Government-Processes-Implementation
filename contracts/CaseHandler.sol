pragma solidity 0.5.0;

import {Graph} from './DataHandler.sol';
import {Ownable} from './Ownable.sol';

contract CaseHandler is Ownable, Graph {
  Case[] public cases;
  Data[] public data;
  mapping (uint32 => address) caseToAddress;
  mapping (address => uint32) caseCount;  // TODO INCREMENT THIS

  struct Case {
    CaseStatus status;
    mapping(bytes32 => Data) dataMapping;
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
    caseToAddress[idx] = user;
    cases.push(Case(CaseStatus.ACTIVE));
    caseCount[user]++;
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










  function getActions(uint caseID) public view returns (bytes32[] memory) {
    /* TODO if case doesnt exist, throw error */
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

  function markData(bytes32 _title, uint _caseID) public {
    /* TODO EXPLANATION AS PARAMETER */

    cases[_caseID].dataMapping[_title].status = Status.MARKED;
    _cascade(_title, _caseID);
  }

  function markAsDone(bytes32 title, uint32 caseID) public {
    cases[caseID].dataMapping[title].status = Status.DONE;
  }

  function _cascade(bytes32 _title, uint caseID) private {
    for (uint i = 0; i < adj[_getIdx(_title)].length; i++) {
      uint adjIdx = adj[_getIdx(_title)][i];
      if (cases[caseID].dataMapping[vxs[adjIdx].title].status == Status.DONE) {
        cases[caseID].dataMapping[vxs[adjIdx].title].status = Status.PENDING;
        _cascade(vxs[adjIdx].title, caseID);
      }
    }
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

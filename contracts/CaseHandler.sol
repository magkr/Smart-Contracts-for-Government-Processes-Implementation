pragma solidity 0.5.0;

import {Graph} from './DataHandler.sol';
import {Ownable} from './Ownable.sol';

contract CaseHandler is Ownable, Graph {
  Case[] public cases;
  mapping (uint32 => address) caseToAddress;
  mapping (address => uint32) caseCount;  // TODO INCREMENT THIS
  event Resolution(bytes32 title, bytes32 dataHash, uint32 dbLocation, uint32 indexed caseID);

  struct Case {
    uint32 id;
    CaseStatus status;
    mapping (bytes32 => Data) dataMapping;
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
  enum Status { UNDONE, DONE, MARKED, UNSTABLE }


  modifier onlyOwnerOf(uint32 _caseID) {
    require(isOwner() || caseToAddress[_caseID] == msg.sender);
    _;
  }

  function addCase(address user) external onlyOwner {
    // if case exist, throw error
    uint32 idx = uint32(cases.length);
    cases.push(Case(idx, CaseStatus.ACTIVE));
    caseToAddress[idx] = user;
    caseCount[user]++;
  }

  function getCases(address user) public view returns (uint32[] memory) {
    require(isOwner() || msg.sender == user);
    if (user == owner()) return _allCases();
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

  function _allCases() private view onlyOwner returns (uint32[] memory) {
    uint32[] memory res = new uint32[](cases.length);
    for(uint32 i = 0; i < cases.length; i++){
        res[i] = i;
    }
    return res;
  }

  function addressFromCase(uint32 caseID) public view onlyOwnerOf(caseID) returns(address) {
    return caseToAddress[caseID];
  }

  function getCase(uint caseID) public view returns(bytes32[] memory titles, bytes32[] memory statuss, uint32[] memory locations) {
    /* TODO sikr det kun er SBH der kan spørge */
    titles = new bytes32[](vxs.length);
    statuss = new bytes32[](vxs.length);
    locations = new uint32[](vxs.length);

    for(uint i = 0; i < vxs.length; i++){
      titles[i] = vxs[i].title;
      statuss[i] = _getStatusString(cases[caseID].dataMapping[vxs[i].title].status);
      locations[i] = cases[caseID].dataMapping[vxs[i].title].dbLocation;
    }
  }





  function fillData(bytes32 _title, uint32 _caseID, bytes32 _dataHash, uint32 _dbLocation) public onlyOwner {
     /* TODO require at dataHash ikke er tom? */
    require(_caseID >= 0 && _caseID <= cases.length);
    cases[_caseID].dataMapping[_title] = Data(_title, _dataHash, _dbLocation, _caseID, Status.DONE);
    if(vxs[_getIdx(_title)].resolution) emit Resolution(_title,  _dataHash, _dbLocation, _caseID);
  }


  function getActions(uint caseID) public view returns (bytes32[] memory) {
    /* TODO if case doesnt exist, throw error */
    bytes32[] memory toDo = new bytes32[](vxs.length);
    uint count = 0;
    Case storage c = cases[caseID];

    for (uint v = 0; v < vxs.length; v++) {
      if (_isReady(v, c)) {
        toDo[count] = vxs[v].title;
        count++;
      }
    }
    return _cut(toDo, count);
  }

  function _isReady(uint v, Case storage c) private view returns (bool) {
    if(c.dataMapping[vxs[v].title].status == Status.DONE) return false;
    for(uint r = 0; r < req[v].length; r++) {
      uint reqID = req[v][r];
      if (c.dataMapping[vxs[reqID].title].status != Status.DONE) return false;
    }
    return true;
  }

  function markData(bytes32 _title, uint _caseID) public {
    /* TODO EXPLANATION AS PARAMETER AND ONLY APPEALSBOARD*/
    Case storage c = cases[_caseID];
    c.dataMapping[_title].status = Status.MARKED;
    _cascade(_getIdx(_title), c);
  }

  function _cascade(uint v, Case storage c) private {
    for (uint i = 0; i < adj[v].length; i++) {
      uint a = adj[v][i];
      if (c.dataMapping[vxs[a].title].status == Status.DONE) {
        c.dataMapping[vxs[a].title].status = Status.UNSTABLE;
        _cascade(a, c);
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
    if (status == Status.UNSTABLE) return "unstable";
    if (status == Status.MARKED) return "marked";
    else return "";  /* TODO THROW ERROR !!! */
  }


}

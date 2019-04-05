pragma solidity 0.5.0;

import {Graph} from './DataHandler.sol';
import {Ownable} from './Ownable.sol';

contract CaseHandler is Ownable, Graph {
  Case[] public cases;
  uint public dataCount;
  mapping (uint32 => address) caseToAddress;
  mapping (address => uint32) caseCount;  // TODO INCREMENT THIS
  event Resolution(bytes32 title, bytes32 dataHash, uint32 indexed caseID, uint indexed id); // should be a dataType instead of bool?
  /* event NewData(bytes32 title, bytes32 dataHash, uint32 , uint32 indexed caseID); // should be a dataType instead of bool? */

  struct Case {
    uint32 id;
    CaseStatus status;
    mapping (bytes32 => Data) dataMapping;
    //mapping (uint => Data[]) extraDatas;
  }

  struct Data {
    bytes32 name;
    bytes32 dataHash;
    uint32 caseID;
    uint id;
    /* DataType dataType; */
    Status status;
  }

  /* event Resolution(Data data); */
  enum CaseStatus { ACTIVE, COMPLAINT, OLD }
  enum Status { UNDONE, DONE, COMPLAINED, MARKED, UNSTABLE }

  modifier onlyUser(uint32 _caseID) {
    require(caseToAddress[_caseID] == msg.sender);
    _;
  }

  modifier ownerOrUser(uint32 _caseID) {
    require(isOwner() || caseToAddress[_caseID] == msg.sender);
    _;
  }

  function _addCase(address user) internal onlyOwner {
    // if case exist, throw error
    uint32 idx = uint32(cases.length);
    cases.push(Case(idx, CaseStatus.ACTIVE));
    caseToAddress[idx] = user;
    caseCount[user]++;
  }

  function _getCases(address user) internal view returns (uint32[] memory) {
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

  function _addressFromCase(uint32 caseID) internal view ownerOrUser(caseID) returns(address) {
    return caseToAddress[caseID];
  }

  function _getCase(uint caseID) internal view returns(bytes32[] memory titles, uint[] memory ids, bytes32[] memory statuss, bytes32[] memory phases, bool[] memory isReady) {
    /* TODO sikr det kun er SBH der kan spørge */
    titles = new bytes32[](vxs.length);
    ids = new uint[](vxs.length);
    statuss = new bytes32[](vxs.length);
    phases = new bytes32[](vxs.length);
    isReady = new bool[](vxs.length);
    Case storage c = cases[caseID];

    for(uint i = 0; i < vxs.length; i++){
      titles[i] = vxs[i].title;
      phases[i] = vxs[i].phase;
      ids[i] = c.dataMapping[vxs[i].title].id;
      statuss[i] = _getStatusString(c.dataMapping[vxs[i].title].status);
      isReady[i] = _isReady(vxs[i].title, c);
    }
  }

  function _fillData(bytes32 _title, uint32 _caseID, bytes32 _dataHash) internal onlyOwner returns (uint id) {
     /* TODO require at dataHash ikke er tom? */
    require(cases[_caseID].status == CaseStatus.ACTIVE && _dataHash.length > 0);
    require(_allowed(_title, cases[_caseID]));
    dataCount++;
    cases[_caseID].dataMapping[_title] = Data(_title, _dataHash, _caseID, dataCount, Status.DONE);
    if (vxs[_getIdx(_title)].resolution) emit Resolution(_title,  _dataHash, _caseID, dataCount);
    return dataCount;
    /* emit NewData(_title,  _dataHash, _caseID); */
  }

  function _allowed(bytes32 v, Case storage c) private view returns (bool) {
    if (c.status == CaseStatus.COMPLAINT) return (c.dataMapping[v].status == Status.COMPLAINED);
    for(uint r = 0; r < req[_getIdx(v)].length; r++) {
      uint reqID = req[_getIdx(v)][r];
      if (c.dataMapping[vxs[reqID].title].status != Status.DONE) return false;
    }
    return true;
  }

  function _isReady(bytes32 v, Case storage c) private view returns (bool) {
    if (c.status == CaseStatus.COMPLAINT) return (c.dataMapping[v].status == Status.COMPLAINED);
    if(c.dataMapping[v].status == Status.DONE) return false;
    for(uint r = 0; r < req[_getIdx(v)].length; r++) {
      uint reqID = req[_getIdx(v)][r];
      if (c.dataMapping[vxs[reqID].title].status != Status.DONE) return false;
    }
    return true;
  }


  function _markData(bytes32 _title, uint _caseID) internal {
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

  function _complain(bytes32 _title, uint32 _caseID) internal onlyUser(_caseID) {
    Case storage c = cases[_caseID];
    c.status = CaseStatus.COMPLAINT;
    for(uint i = 0; i < vxs.length; i++) {
      if (vxs[i].phase == _title) c.dataMapping[vxs[i].title].status = Status.COMPLAINED;
    }
  }

  /* function _cut(bytes32[] memory arr, uint count) internal pure returns (bytes32[] memory) {
    bytes32[] memory res = new bytes32[](count);
    for (uint i = 0; i < count; i++) { res[i] = arr[i]; }
    return res;
  } */

  function _getStatusString(Status status) internal pure returns(bytes32) {
    if (status == Status.DONE) return "done";
    if (status == Status.UNDONE) return "undone";
    if (status == Status.UNSTABLE) return "unstable";
    if (status == Status.MARKED) return "marked";
    else return "";  /* TODO THROW ERROR !!! */
  }

}

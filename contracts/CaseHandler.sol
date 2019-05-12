pragma solidity 0.5.0;

import {Graph} from './Graph.sol';
import {RBAC} from './RBAC.sol';

contract CaseHandler is RBAC, Graph {
  Case[] cases;
  uint32 public dataCount;

  mapping (uint32 => address) caseToAddress;
  mapping (address => uint32) caseCount;

  enum CaseStatus { ACTIVE, APPEALED, APPEALSBOARD }
  enum Status { UNDONE, DONE, UNSTABLE, MARKED, APPEALED }

  event NewData(bytes32 title, bytes32 dataHash, uint32 indexed caseID, uint location, uint indexed dataType);

  struct Case {
    uint32 id;
    CaseStatus status;
    mapping (bytes32 => Data) dataMapping;
  }

  struct Data {
    bytes32 dataHash;
    uint32 caseID;
    uint32 id;
    Status status;
  }


  function _addCase(address user) internal {
    require(!hasRole(user, MUNICIPALITY) || !hasRole(user, APPEALSBOARD));
    uint32 idx = uint32(cases.length);
    cases.push(Case(idx, CaseStatus.ACTIVE));
    caseToAddress[idx] = user;
    caseCount[user]++;
    _addRole(user, CITIZEN);
  }

  function _myCases() internal view returns (uint32[] memory cs, CaseStatus[] memory statuss) {
    cs = new uint32[](caseCount[msg.sender]);
    statuss = new CaseStatus[](caseCount[msg.sender]);
    uint32 counter = 0;

    for(uint32 i = 0; counter < caseCount[msg.sender] && i < cases.length; i++){
      if (caseToAddress[i] == msg.sender){
        cs[counter] = cases[i].id;
        statuss[counter] = cases[i].status;
        counter++;
      }
    }
  }

  function _allCases() internal view returns (uint32[] memory cs, CaseStatus[] memory statuss) {
    cs = new uint32[](cases.length);
    statuss = new CaseStatus[](cases.length);

    for(uint32 i = 0; i < cases.length; i++){
        cs[i] = cases[i].id;
        statuss[i] = cases[i].status;
    }
  }

  function _addressFromCase(uint32 caseID) internal view returns(address) {
    return caseToAddress[caseID];
  }

  function _getCase(uint32 caseID) internal view returns(bytes32[] memory titles, uint32[] memory ids, bytes32[] memory dataHashes, Status[] memory statuss, uint[] memory types, bytes32[] memory phases, bool[] memory isReady) {
    titles = new bytes32[](activities.length);
    ids = new uint32[](activities.length);
    dataHashes = new bytes32[](activities.length);
    statuss = new Status[](activities.length);
    phases = new bytes32[](activities.length);
    isReady = new bool[](activities.length);
    types = new uint[](activities.length);
    Case storage c = cases[caseID];

    for(uint i = 0; i < activities.length; i++){
      Data storage d = c.dataMapping[activities[i].title];
      titles[i] = activities[i].title;
      phases[i] = activities[i].phase;
      types[i] = uint(activities[i].aType);
      ids[i] = d.id;
      dataHashes[i] = d.dataHash;
      statuss[i] = d.status;
      isReady[i] = _isReady(activities[i].title, c);
    }
  }


  function _isReady(bytes32 v, Case storage c) private view returns (bool) {
    if(c.dataMapping[v].status == Status.DONE) return false;
    return _allowed(v, c);
  }

  function _allowed(bytes32 v, Case storage c) internal view returns (bool) {
    for(uint r = 0; r < req[_getIdx(v)].length; r++) {
      uint reqID = req[_getIdx(v)][r];
      if (c.dataMapping[activities[reqID].title].status != Status.DONE) return false;
    }
    return true;
  }

}

pragma solidity 0.5.0;

import {Graph} from './Graph.sol';
import {RBAC} from './RBAC.sol';

contract CaseHandler is RBAC, Graph {
  Case[] cases;
  uint public dataCount;
  mapping (uint32 => address) caseToAddress;
  mapping (address => uint32) caseCount;  // TODO INCREMENT THIS
  mapping (uint32 => Complaint) complaints;

  enum CaseStatus { ACTIVE, COMPLAINT, READYFORPAYMENT, COUNCIL }
  enum Status { UNDONE, DONE, UNSTABLE, MARKED, COMPLAINED }
  event NewData(bytes32 title, bytes32 dataHash, uint32 indexed caseID, uint location, uint indexed dataType ); // should be a dataType instead of bool?

  struct Case {
    uint32 id;
    CaseStatus status;
    mapping (bytes32 => Data) dataMapping;
  }

  struct Data {
    bytes32 name;
    bytes32 dataHash;
    uint32 caseID;
    uint id;
    Status status;
  }

  struct Complaint {
    bytes32 data;
    uint caseID;
    bool isMarked;
  }


  function _addCase(address user) internal {
    // if case exist, throw error
    require(!hasRole(user, MUNICIPALITY) || !hasRole(user, COUNCIL));
    uint32 idx = uint32(cases.length);
    cases.push(Case(idx, CaseStatus.ACTIVE));
    caseToAddress[idx] = user;
    caseCount[user]++;
    _addRole(user, CITIZEN);
  }

  function _myCases() internal view returns (uint32[] memory cs, CaseStatus[] memory statuss) {
    /* if (msg.sender == ANKESTYRELSE) RETURN COMPLAINs */
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

  function _councilCases() internal view returns (uint32[] memory cs, CaseStatus[] memory statuss) {
    uint count = 0;

    for(uint32 i = 0; i < cases.length; i++){
      if (cases[i].status == CaseStatus.COUNCIL)
        count++;
    }

    cs = new uint32[](count);
    statuss = new CaseStatus[](count);

    for(uint32 i = 0; i < cases.length; i++){
      if (cases[i].status == CaseStatus.COUNCIL) {
        cs[i] = cases[i].id;
        statuss[i] = cases[i].status;
      }
    }
  }

  function _addressFromCase(uint32 caseID) internal view returns(address) {
    return caseToAddress[caseID];
  }

  function _getCase(uint caseID) internal view returns(bytes32[] memory titles, uint[] memory ids, bytes32[] memory dataHashes, Status[] memory statuss, uint[] memory types, bytes32[] memory phases, bool[] memory isReady) {
    titles = new bytes32[](vxs.length);
    ids = new uint[](vxs.length);
    dataHashes = new bytes32[](vxs.length);
    statuss = new Status[](vxs.length);
    phases = new bytes32[](vxs.length);
    isReady = new bool[](vxs.length);
    types = new uint[](vxs.length);
    Case storage c = cases[caseID];

    for(uint i = 0; i < vxs.length; i++){
      Data storage d = c.dataMapping[vxs[i].title];
      titles[i] = vxs[i].title;
      phases[i] = vxs[i].phase;
      types[i] = uint(vxs[i].nodeType);
      ids[i] = d.id;
      dataHashes[i] = d.dataHash;
      statuss[i] = d.status;
      isReady[i] = _isReady(vxs[i].title, c);
    }
  }


  function _allowed(bytes32 v, Case storage c) internal view returns (bool) {
    for(uint r = 0; r < req[_getIdx(v)].length; r++) {
      uint reqID = req[_getIdx(v)][r];
      if (c.dataMapping[vxs[reqID].title].status != Status.DONE) return false;
    }
    return true;
  }

  function _isReady(bytes32 v, Case storage c) private view returns (bool) {
    if(c.dataMapping[v].status == Status.DONE) return false;
    for(uint r = 0; r < req[_getIdx(v)].length; r++) {
      uint reqID = req[_getIdx(v)][r];
      if (c.dataMapping[vxs[reqID].title].status != Status.DONE) return false;
    }
    return true;
  }

  function _cascade(uint v, Case storage c, Status from, Status to) internal {
    for (uint i = 0; i < adj[v].length; i++) {
      uint a = adj[v][i];
      if (c.dataMapping[vxs[a].title].status == from) {
        c.dataMapping[vxs[a].title].status = to;
        _cascade(a, c, from, to);
      }
    }
  }

}

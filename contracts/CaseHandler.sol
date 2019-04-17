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
  enum Status { UNDONE, DONE, COMPLAINED, MARKED, UNSTABLE }
  event NewData(bytes32 title, bytes32 dataHash, uint32 indexed caseID, uint location, bool indexed resolution); // should be a dataType instead of bool?
  /* event Resolution(Data data); */

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

  function complaintCases() public view returns (uint32[] memory cs, CaseStatus[] memory statuss) {
    uint count = 0;

    for(uint32 i = 0; i < cases.length; i++){
      if (cases[i].status == CaseStatus.COMPLAINT)
        count++;
    }

    cs = new uint32[](count);
    statuss = new CaseStatus[](count);

    for(uint32 i = 0; i < cases.length; i++){
      if (cases[i].status == CaseStatus.COMPLAINT) {
        cs[i] = cases[i].id;
        statuss[i] = cases[i].status;
      }
    }
  }

  function _addressFromCase(uint32 caseID) internal view returns(address) {
    return caseToAddress[caseID];
  }

  function _getCase(uint caseID) internal view returns(bytes32[] memory titles, uint[] memory ids, bytes32[] memory statuss, uint[] memory types, bytes32[] memory phases, bool[] memory isReady) {
    titles = new bytes32[](vxs.length);
    ids = new uint[](vxs.length);
    statuss = new bytes32[](vxs.length);
    phases = new bytes32[](vxs.length);
    isReady = new bool[](vxs.length);
    types = new uint[](vxs.length);
    Case storage c = cases[caseID];

    for(uint i = 0; i < vxs.length; i++){
      titles[i] = vxs[i].title;
      phases[i] = vxs[i].phase;
      types[i] = uint(vxs[i].nodeType);
      ids[i] = c.dataMapping[vxs[i].title].id;
      statuss[i] = _getStatusString(c.dataMapping[vxs[i].title].status);
      isReady[i] = _isReady(vxs[i].title, c);
    }
  }

  function _fillDatas(bytes32[] memory _titles, uint32 _caseID, bytes32[] memory _dataHashes) internal returns (uint[] memory ids) {
    ids = new uint[](_titles.length);
    if(cases[_caseID].status == CaseStatus.ACTIVE) {
      for(uint i = 0; i < _titles.length; i++) {
        ids[i] = _activeFillData(_titles[i], _caseID, _dataHashes[i]);
      }
    }
    else if(cases[_caseID].status == CaseStatus.COMPLAINT) {
      for(uint i = 0; i < _titles.length; i++) {
        ids[i] = _complainFillData(_titles[i], _caseID, _dataHashes[i]);
      }
    }
  }

  function _fillData(bytes32 _title, uint32 _caseID, bytes32 _dataHash) internal returns (uint id) {
    if(cases[_caseID].status == CaseStatus.ACTIVE) return _activeFillData(_title, _caseID, _dataHash);
    else if(cases[_caseID].status == CaseStatus.COMPLAINT) return _complainFillData(_title, _caseID, _dataHash);
  }

  function _activeFillData(bytes32 _title, uint32 _caseID, bytes32 _dataHash) internal returns (uint id) {
    require(cases[_caseID].status == CaseStatus.ACTIVE);
    require(_allowed(_title, cases[_caseID]));
    Case storage c = cases[_caseID];

    dataCount++;
    c.dataMapping[_title] = Data(_title, _dataHash, _caseID, dataCount, Status.DONE);

    if(c.dataMapping[lastVtx].status == Status.DONE) {
      c.status = CaseStatus.READYFORPAYMENT;
    }

    emit NewData(_title,  _dataHash, _caseID, dataCount, vxs[_getIdx(_title)].resolution);
    return dataCount;
  }

  function _complainFillData(bytes32 _title, uint32 _caseID, bytes32 _dataHash) internal returns (uint id) {
    require(cases[_caseID].status == CaseStatus.COMPLAINT);
    Case storage c = cases[_caseID];
    if(c.dataMapping[_title].dataHash != _dataHash) {
      dataCount++;
      if(complaints[_caseID].data == _title) {
        c.status = CaseStatus.ACTIVE;
        if(c.dataMapping[lastVtx].status == Status.DONE) {
          c.status = CaseStatus.READYFORPAYMENT;
        }
        //TODO emit decision;
      }
      c.dataMapping[_title] = Data(_title, _dataHash, _caseID, dataCount, Status.DONE);
      emit NewData(_title,  _dataHash, _caseID, dataCount, vxs[_getIdx(_title)].resolution);

      return dataCount;
    } else {
      c.dataMapping[_title].status = Status.DONE;
      if(complaints[_caseID].data == _title) {
        c.status = CaseStatus.COUNCIL;
      }
      return c.dataMapping[_title].id;
    }
  }

  function _allowed(bytes32 v, Case storage c) private view returns (bool) {
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

  function _getComplaint(uint32 _caseID) internal view returns (bytes32, bool){
    Complaint memory complaint = complaints[_caseID];
    return (complaint.data, complaint.isMarked);
  }

  function _markData(bytes32 _title, uint32 _caseID) internal {
    /* TODO EXPLANATION AS PARAMETER AND ONLY APPEALSBOARD*/
    require(cases[_caseID].status == CaseStatus.COUNCIL);
    Case storage c = cases[_caseID];
    c.dataMapping[_title].status = Status.MARKED;
    complaints[_caseID].isMarked = true;
    _cascade(_getIdx(_title), c, Status.DONE, Status.UNSTABLE);
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

  function _stadfast(uint32 _caseID) internal {
    require(cases[_caseID].status == CaseStatus.COUNCIL && !complaints[_caseID].isMarked);
    Case storage c = cases[_caseID];
    c.status = CaseStatus.ACTIVE;
    //EMIT EVENT
  }

  function _homesend(uint32 _caseID) internal {
    require(cases[_caseID].status == CaseStatus.COUNCIL && complaints[_caseID].isMarked);
    Case storage c = cases[_caseID];
    c.status = CaseStatus.COMPLAINT;
  }

  function _complain(bytes32 _title, uint32 _caseID) internal {
    require(cases[_caseID].status != CaseStatus.COMPLAINT);
    Case storage c = cases[_caseID];
    c.status = CaseStatus.COMPLAINT;
    for(uint i = 0; i < vxs.length; i++) {
      if (vxs[i].phase == _title) c.dataMapping[vxs[i].title].status = Status.COMPLAINED;
    }
    _cascade(_getIdx(_title), c, Status.DONE, Status.UNSTABLE);
    complaints[_caseID] = Complaint(_title, _caseID, false);
  }

  function _getStatusString(Status status) internal pure returns(bytes32) {
    if (status == Status.DONE) return "done";
    if (status == Status.UNDONE) return "undone";
    if (status == Status.UNSTABLE) return "unstable";
    if (status == Status.MARKED) return "marked";
    if (status == Status.COMPLAINED) return "complained";
    else return "";  /* TODO THROW ERROR !!! */
  }

}

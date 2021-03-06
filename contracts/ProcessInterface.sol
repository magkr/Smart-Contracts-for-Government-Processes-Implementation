pragma solidity 0.5.0;

import {TransferHandler} from "./TransferHandler.sol";

contract ProcessInterface is TransferHandler {

  function addCase(address user) public onlyRole(MUNICIPALITY) {
    return _addCase(user);
  }

  function addressFromCase(uint32 caseID) public view anyRole returns(address) {
    if (hasRole(msg.sender, CITIZEN)) { require(_addressFromCase(caseID) == msg.sender); }
    return _addressFromCase(caseID);
  }

  function getCase(uint32 caseID) public view onlyAdmin returns(bytes32[] memory titles, uint32[] memory ids, bytes32[] memory dataHashes, Status[] memory statuss, uint[] memory types, bytes32[] memory phases, bool[] memory isReady) {
    return _getCase(caseID);
  }

  function fillData(bytes32 _title, uint32 _caseID, bytes32 _dataHash) public returns (uint32 id) {
    if (activities[_getIdx(_title)].aType == ActivityType.DOC)
      require((caseToAddress[_caseID] == msg.sender) || hasRole(msg.sender, MUNICIPALITY));
    else require(hasRole(msg.sender, MUNICIPALITY));
    return _fillData(_title, _caseID, _dataHash);
  }

  function fillDatas(bytes32[] memory _titles, uint32 _caseID, bytes32[] memory _dataHashes) public returns (uint32[] memory ids) {
    ids = new uint32[](_titles.length);
    for(uint i = 0; i < _titles.length; i++) {
      ids[i] = fillData(_titles[i], _caseID, _dataHashes[i]);
    }
  }

  function allCases() public view onlyAdmin returns (uint32[] memory ids,  CaseStatus[] memory sts) {
    return _allCases();
  }

  function myCases() public view onlyRole(CITIZEN) returns (uint32[] memory ids, CaseStatus[] memory sts) {
    return _myCases();
  }

  function markData(bytes32 _title, uint32 _caseID) public onlyRole(APPEALSBOARD) {
    return _markData(_title, _caseID);
  }

  function ratify(uint32 _caseID) public onlyRole(APPEALSBOARD) {
    return _ratify(_caseID);
  }

  function redo(uint32 _caseID) public onlyRole(APPEALSBOARD) {
    return _redo(_caseID);
  }

  function appeal(bytes32 _title, uint32 _caseID) public onlyRole(CITIZEN) {
    return _appeal(_title, _caseID);
  }

  function sendEther(uint32 _caseID) public payable onlyRole(MUNICIPALITY) {
    return _sendEther(_caseID);
  }

  function setAppealsBoard(address c) public {
    return _addRole(c, APPEALSBOARD);
  }
}

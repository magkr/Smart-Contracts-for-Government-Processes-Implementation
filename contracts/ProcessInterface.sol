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

  function getCase(uint caseID) public view onlyAdmin returns(bytes32[] memory titles, uint[] memory ids, bytes32[] memory statuss, bytes32[] memory phases, bool[] memory isReady) {
    return _getCase(caseID);
  }

  function fillData(bytes32 _title, uint32 _caseID, bytes32 _dataHash) public onlyRole(MUNICIPALITY) returns (uint id) {
    return _fillData(_title, _caseID, _dataHash);
  }

  function allCases() public view onlyAdmin returns (uint32[] memory ids,  CaseStatus[] memory sts) {
    return _allCases();
  }

  function myCases() public view onlyRole(CITIZEN) returns (uint32[] memory ids, CaseStatus[] memory sts) {
    return _myCases();
  }

  function markData(bytes32 _title, uint _caseID) public onlyRole(COUNCIL) {
    return _markData(_title, _caseID);
  }

  function complain(bytes32 _title, uint32 _caseID) public onlyRole(CITIZEN) {
    return _complain(_title, _caseID);
  }

  function sendEther(uint32 _caseID) public payable onlyRole(MUNICIPALITY) {
    return _sendEther(_caseID);
  }

  function addRole(address _operator, string memory _role) public onlyAdmin {
    require(hasRole(msg.sender, _role));
    return _addRole(_operator, _role);
  }

  function removeRole(address _operator, string memory _role) public onlyAdmin {
    require(hasRole(msg.sender, _role) && msg.sender != _operator);
    return _removeRole(_operator, _role);
  }
}

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

  function getCase(uint caseID) public view onlyAdmin returns(bytes32[] memory titles, uint[] memory ids, bytes32[] memory statuss, uint[] memory types, bytes32[] memory phases, bool[] memory isReady) {
    return _getCase(caseID);
  }

  function fillData(bytes32 _title, uint32 _caseID, bytes32 _dataHash) public returns (uint id) {
    if (vxs[_getIdx(_title)].nodeType == NodeType.DOC) require((caseToAddress[_caseID] == msg.sender) || hasRole(msg.sender, MUNICIPALITY));
    else require(hasRole(msg.sender, MUNICIPALITY));
    return _fillData(_title, _caseID, _dataHash);
  }

  function fillDatas(bytes32[] memory _titles, uint32 _caseID, bytes32[] memory _dataHashes) public returns (uint[] memory ids) {
    require(hasRole(msg.sender, MUNICIPALITY));
    return _fillDatas(_titles, _caseID, _dataHashes);
  }

  function allCases() public view onlyAdmin returns (uint32[] memory ids,  CaseStatus[] memory sts) {
    return _allCases();
  }

  function myCases() public view onlyRole(CITIZEN) returns (uint32[] memory ids, CaseStatus[] memory sts) {
    return _myCases();
  }

  function markData(bytes32 _title, uint32 _caseID) public onlyRole(COUNCIL) {
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

  function stadfast(uint32 _caseID) public onlyRole(COUNCIL) {
    return _stadfast(_caseID);
  }

  function homesend(uint32 _caseID) public onlyRole(COUNCIL) {
    return _homesend(_caseID);
  }

  function getComplaint(uint32 _caseID) public view returns (bytes32, bool){
    return _getComplaint(_caseID);
  }
}

pragma solidity 0.5.0;

import {TransferHandler} from "./TransferHandler.sol";

contract ProcessInterface is TransferHandler {

  function addCase(address user) public onlyOwner {
    return _addCase(user);
  }

  function addressFromCase(uint32 caseID) public view ownerOrUser(caseID) returns(address) {
    return _addressFromCase(caseID);
  }

  function getCase(uint caseID) public view returns(bytes32[] memory titles, uint[] memory ids, bytes32[] memory statuss, bytes32[] memory phases, bool[] memory isReady) {
    return _getCase(caseID);
  }

  function fillData(bytes32 _title, uint32 _caseID, bytes32 _dataHash) public onlyOwner returns (uint id) {
    return _fillData(_title, _caseID, _dataHash);
  }

  function getCases(address user) public view returns (uint32[] memory) {
    return _getCases(user);
  }

  function markData(bytes32 _title, uint _caseID) public {
    return _markData(_title, _caseID);
  }

  function complain(bytes32 _title, uint32 _caseID) public onlyUser(_caseID) {
    return _complain(_title, _caseID);
  }

  function sendEther(uint _amount, uint32 _caseID) public payable onlyOwner {
    return _sendEther(_amount, _caseID);
  }
}

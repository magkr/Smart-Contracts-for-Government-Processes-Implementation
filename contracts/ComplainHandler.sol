pragma solidity 0.5.0;

import {Ownable} from "./Ownable.sol";

contract ProcessInterface {
  function addressFromCase(uint32 caseID) public view returns(address);
  function getCase(uint caseID) public view returns(bytes32[] memory titles, uint[] memory ids, bytes32[] memory statuss, bytes32[] memory phases, bool[] memory isReady);
  /* function fillData(bytes32 _title, uint32 _caseID, bytes32 _dataHash) public returns (uint id); */
  function allCases() public view returns (uint32[] memory);
  function markData(bytes32 _title, uint _caseID) public;
}


contract ComplainHandler is Ownable {

  ProcessInterface municipality;

  function setMunicipality(address addr) public onlyOwner {
    municipality = ProcessInterface(addr);
  }

  function markData(bytes32 _title, uint _caseID) public onlyOwner {
    municipality.markData(_title, _caseID);
  }

  function addressFromCase(uint32 caseID) public view returns(address) {
    return municipality.addressFromCase(caseID);
  }

  function getCase(uint caseID) public view returns(bytes32[] memory titles, uint[] memory ids, bytes32[] memory statuss, bytes32[] memory phases, bool[] memory isReady) {
    return municipality.getCase(caseID);
  }

  function allCases() public pure returns (uint32[] memory) {
  }


}

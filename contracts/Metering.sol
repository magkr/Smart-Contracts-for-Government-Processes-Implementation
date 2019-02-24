pragma solidity ^0.5.0;

import './Process.sol';

contract Metering is Process {

  constructor() public {
    _addData("Arbejdstider");
    _addData("Familieforhold");
    _addData("Arbejdsfleksibilitet");
    _addData("Vurdering af timer");
    _addData("Vurdering af sparede udgifter");
    _addData("Beregning");

    _addEdge("root","Arbejdstider");
    _addEdge("root","Familieforhold");
    _addEdge("root","Arbejdsfleksibilitet");

    _addEdge("Arbejdstider","Vurdering af timer");
    _addEdge("Arbejdstider","Vurdering af sparede udgifter");
    _addEdge("Familieforhold","Vurdering af timer");
    _addEdge("Familieforhold","Vurdering af af sparede udgifter");
    _addEdge("Arbejdsfleksibilitet","Vurdering af timer");
    _addEdge("Arbejdsfleksibilitet","Vurdering af af sparede udgifter");

  }


  /* function possibleActions() returns (Data[] storage) {

  } */
}

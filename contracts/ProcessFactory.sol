pragma solidity 0.5.0;

import {Process42} from "./Process42.sol";

contract ProcessFactory is Process42 {

  /* IDEA
  bytes32[] vs;
  bytes32[] edges;

  function ...() {
    vs = [bytes32("a"), "ba", "bb", "c"];
    edges = [
      bytes32("root"), "a",
      "a", "ba",
      "a", "bb",
      "ba", "c",
      "bb", "c"];

    for (uint i = 0; i < vs.length; i++) _addVertex(vs[i]);
    for (uint i = 0; i < edges.length; i+=2) _addEdge(edges[i], edges[(i+1)]);
  }
  */

  constructor() public {
    metering();
    beregningsgrundlag();
  }

  function metering() public {
    bytes32 root = "root";
    _addVertex("Arbejdstider", DataType.INT);
    _addVertex("Familieforhold", DataType.INT);
    _addVertex("Arbejdsfleksibilitet", DataType.INT);
    _addVertex("Bevilligede timer", DataType.INT);
    _addVertex("Sparede udgifter", DataType.INT);
    _addVertex("Udmåling afgørelse", DataType.INT);

    _addEdge(root,"Arbejdstider");
    _addEdge(root,"Familieforhold");
    _addEdge(root,"Arbejdsfleksibilitet");

    _addEdge("Arbejdstider","Bevilligede timer");
    _addEdge("Arbejdstider","Sparede udgifter");
    _addEdge("Familieforhold","Bevilligede timer");
    _addEdge("Familieforhold","Sparede udgifter");
    _addEdge("Arbejdsfleksibilitet","Bevilligede timer");
    _addEdge("Arbejdsfleksibilitet","Sparede udgifter");
    _addEdge("Bevilligede timer", "Udmåling afgørelse");
    _addEdge("Sparede udgifter", "Udmåling afgørelse");
  }

  function beregningsgrundlag() public {
    bytes32 root = "Udmåling afgørelse";
    _addVertex("Indkomstoplysninger", DataType.INT);
    _addVertex("Skatteoplysninger", DataType.INT);
    _addVertex("Pensionsoplysninger", DataType.INT);

    _addVertex("Beregning af ydelse", DataType.INT);
    _addVertex("Pensionsselskabs info", DataType.INT);

    _addVertex("Beregningsgrundlag afgørelse", DataType.INT);

    _addEdge(root,"Indkomstoplysninger");
    _addEdge(root,"Skatteoplysninger");
    _addEdge(root,"Pensionsoplysninger");

    _addEdge("Indkomstoplysninger", "Beregning af ydelse");
    _addEdge("Skatteoplysninger", "Beregning af ydelse");
    _addEdge("Pensionsoplysninger", "Beregning af ydelse");
    _addEdge("Pensionsoplysninger", "Pensionsselskabs info");

    _addEdge("Beregning af ydelse", "Beregningsgrundlag afgørelse");
    _addEdge("Pensionsselskabs info", "Beregningsgrundlag afgørelse");
  }

}

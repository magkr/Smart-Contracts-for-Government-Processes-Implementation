pragma solidity 0.5.0;

import {CaseHandler} from "./CaseHandler.sol";

contract Process42 is CaseHandler {

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
    /* beregningsgrundlag(); */
  }

  function metering() public {
    bytes32 root = "root";
    _addVertex("Arbejdstider", true);
    _addVertex("Familieforhold", true);
    _addVertex("Arbejdsfleksibilitet", true);
    _addVertex("Bevilligede timer", true);
    _addVertex("Sparede udgifter", true);
    _addVertex("Udmåling afgørelse", true);

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

  /* function metering() public {
    bytes32 root = "root";
    _addVertex("Arbejdstider", DataType.INT, NodeType.NORMAL, false);
    _addVertex("Familieforhold", DataType.INT, NodeType.NORMAL, false);
    _addVertex("Arbejdsfleksibilitet", DataType.INT, NodeType.NORMAL, false);
    _addVertex("Bevilligede timer", DataType.INT, NodeType.NORMAL, false);
    _addVertex("Sparede udgifter", DataType.INT, NodeType.NORMAL, false);
    _addVertex("Udmåling afgørelse", DataType.INT, NodeType.NORMAL, true);

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
  } */

  /* function beregningsgrundlag() public {
    bytes32 root = "Udmåling afgørelse";
    _addVertex("Indkomstoplysninger", DataType.INT, NodeType.NORMAL);
    _addVertex("Skatteoplysninger", DataType.INT, NodeType.NORMAL);
    _addVertex("Pensionsoplysninger", DataType.INT, NodeType.NORMAL);

    _addVertex("Beregning af ydelse", DataType.INT, NodeType.NORMAL);
    _addVertex("Pensionsselskabs info", DataType.INT, NodeType.NORMAL);

    _addVertex("Beregningsgrundlag afgørelse", DataType.INT, NodeType.NORMAL);

    _addEdge(root,"Indkomstoplysninger");
    _addEdge(root,"Skatteoplysninger");
    _addEdge(root,"Pensionsoplysninger");

    _addEdge("Indkomstoplysninger", "Beregning af ydelse");
    _addEdge("Skatteoplysninger", "Beregning af ydelse");
    _addEdge("Pensionsoplysninger", "Beregning af ydelse");
    _addEdge("Pensionsoplysninger", "Pensionsselskabs info");

    _addEdge("Beregning af ydelse", "Beregningsgrundlag afgørelse");
    _addEdge("Pensionsselskabs info", "Beregningsgrundlag afgørelse");
  } */

}

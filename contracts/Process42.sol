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
    beregningsgrundlag();
  }

  function metering() public {
    bytes32 root = "root";
    _addVertex("Arbejdstider", true);
    _addVertex("Familieforhold", false);
    _addVertex("Arbejdsfleksibilitet", true);
    _addVertex("Bevilligede timer", false);
    _addVertex("Sparede udgifter", false);
    _addVertex("Udmaaling afgoerelse", true);

    _addEdge(root,"Arbejdstider");
    _addEdge(root,"Familieforhold");
    _addEdge(root,"Arbejdsfleksibilitet");

    _addEdge("Arbejdstider","Bevilligede timer");
    _addEdge("Arbejdstider","Sparede udgifter");
    _addEdge("Familieforhold","Bevilligede timer");
    _addEdge("Familieforhold","Sparede udgifter");
    _addEdge("Arbejdsfleksibilitet","Bevilligede timer");
    _addEdge("Arbejdsfleksibilitet","Sparede udgifter");
    _addEdge("Bevilligede timer", "Udmaaling afgoerelse");
    _addEdge("Sparede udgifter", "Udmaaling afgoerelse");
  }

  /* function metering() public {
    bytes32 root = "root";
    _addVertex("Arbejdstider", DataType.INT, NodeType.NORMAL, false);
    _addVertex("Familieforhold", DataType.INT, NodeType.NORMAL, false);
    _addVertex("Arbejdsfleksibilitet", DataType.INT, NodeType.NORMAL, false);
    _addVertex("Bevilligede timer", DataType.INT, NodeType.NORMAL, false);
    _addVertex("Sparede udgifter", DataType.INT, NodeType.NORMAL, false);
    _addVertex("Udmaaling afgoerelse", DataType.INT, NodeType.NORMAL, true);

    _addEdge(root,"Arbejdstider");
    _addEdge(root,"Familieforhold");
    _addEdge(root,"Arbejdsfleksibilitet");

    _addEdge("Arbejdstider","Bevilligede timer");
    _addEdge("Arbejdstider","Sparede udgifter");
    _addEdge("Familieforhold","Bevilligede timer");
    _addEdge("Familieforhold","Sparede udgifter");
    _addEdge("Arbejdsfleksibilitet","Bevilligede timer");
    _addEdge("Arbejdsfleksibilitet","Sparede udgifter");
    _addEdge("Bevilligede timer", "Udmaaling afgoerelse");
    _addEdge("Sparede udgifter", "Udmaaling afgoerelse");
  } */

  function beregningsgrundlag() public {
    bytes32 root = "Udmaaling afgoerelse";
    _addVertex("Indkomstoplysninger", false);
    _addVertex("Skatteoplysninger", false);
    _addVertex("Pensionsoplysninger", false);

    _addVertex("Beregning af ydelse", false);
    _addVertex("Pensionsselskabs info", false);

    _addVertex("Beregningsgrundlag afgoerelse", true);

    _addEdge(root,"Indkomstoplysninger");
    _addEdge(root,"Skatteoplysninger");
    _addEdge(root,"Pensionsoplysninger");

    _addEdge("Indkomstoplysninger", "Beregning af ydelse");
    _addEdge("Skatteoplysninger", "Beregning af ydelse");
    _addEdge("Pensionsoplysninger", "Beregning af ydelse");
    _addEdge("Pensionsoplysninger", "Pensionsselskabs info");

    _addEdge("Beregning af ydelse", "Beregningsgrundlag afgoerelse");
    _addEdge("Pensionsselskabs info", "Beregningsgrundlag afgoerelse");
  }
}

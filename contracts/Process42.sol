pragma solidity 0.5.0;

import {ProcessInterface} from "./ProcessInterface.sol";

contract Process42 is ProcessInterface {

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

  function metering() private {
    bytes32 root = "root";
    _addVertex("Arbejdstider","Udmaaling", false);
    _addVertex("Familieforhold", "Udmaaling", false);
    _addVertex("Arbejdsfleksibilitet", "Udmaaling", false);
    _addVertex("Bevilligede timer", "Udmaaling", false);
    _addVertex("Sparede udgifter", "Udmaaling", false);
    _addVertex("Udmaaling", "Udmaaling", true);

    _addEdge(root,"Arbejdstider");
    _addEdge(root,"Familieforhold");
    _addEdge(root,"Arbejdsfleksibilitet");

    _addEdge("Arbejdstider","Bevilligede timer");
    _addEdge("Arbejdstider","Sparede udgifter");
    _addEdge("Familieforhold","Bevilligede timer");
    _addEdge("Familieforhold","Sparede udgifter");
    _addEdge("Arbejdsfleksibilitet","Bevilligede timer");
    _addEdge("Arbejdsfleksibilitet","Sparede udgifter");
    _addEdge("Bevilligede timer", "Udmaaling");
    _addEdge("Sparede udgifter", "Udmaaling");
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

  function beregningsgrundlag() private {
    bytes32 root = "Udmaaling";
    _addVertex("Indkomstoplysninger", "Beregningsgrundlag", false);
    _addVertex("Skatteoplysninger", "Beregningsgrundlag", false);
    _addVertex("Pensionsoplysninger", "Beregningsgrundlag", false);

    _addVertex("Beregning af ydelse", "Beregningsgrundlag", false);
    _addVertex("Pensionsselskabs info", "Beregningsgrundlag", false);

    _addVertex("Beregningsgrundlag", "Beregningsgrundlag", true);

    _addEdge(root,"Indkomstoplysninger");
    _addEdge(root,"Skatteoplysninger");
    _addEdge(root,"Pensionsoplysninger");

    _addEdge("Indkomstoplysninger", "Beregning af ydelse");
    _addEdge("Skatteoplysninger", "Beregning af ydelse");
    _addEdge("Pensionsoplysninger", "Beregning af ydelse");
    _addEdge("Pensionsoplysninger", "Pensionsselskabs info");

    _addEdge("Beregning af ydelse", "Beregningsgrundlag");
    _addEdge("Pensionsselskabs info", "Beregningsgrundlag");
  }
}

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
    /* metering();
    beregningsgrundlag();
    udbetaling();
    resolvingResolution = "Beregningsgrundlag";
    lastEdge = "Udbetaling"
*/

    test();
    resolvingResolution = "Resolution";
    lastVtx = "Final";
  }

  function metering() private {
    _addVertex("Arbejdstider","Udmaaling", false, NodeType.DOC);
    _addVertex("Familieforhold", "Udmaaling", false, NodeType.NORMAL);
    _addVertex("Arbejdsfleksibilitet", "Udmaaling", false, NodeType.NORMAL);
    _addVertex("Bevilligede timer", "Udmaaling", false, NodeType.NORMAL);
    _addVertex("Sparede udgifter", "Udmaaling", false, NodeType.NORMAL);
    _addVertex("Udmaaling", "Udmaaling", true, NodeType.RESOLUTION);

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

  function test() private {
    _addVertex("Normal","Resolution", false, NodeType.DOC);
    _addVertex("Resolution", "Resolution", true, NodeType.RESOLUTION);
    _addVertex("Documentation", "Final", false, NodeType.DOC);
    _addVertex("Final", "Final", true, NodeType.RESOLUTION);


    _addEdge(root,"Normal");
    _addEdge("Normal","Resolution");

    _addEdge("Resolution","Documentation");
    _addEdge("Documentation","Final");
    _addEdge("Final",end);

  }

  function beregningsgrundlag() private {
    _addVertex("Indkomstoplysninger", "Beregningsgrundlag", false, NodeType.DOC);
    _addVertex("Skatteoplysninger", "Beregningsgrundlag", false, NodeType.DOC);
    _addVertex("Pensionsoplysninger", "Beregningsgrundlag", false, NodeType.DOC);

    _addVertex("Beregning af ydelse", "Beregningsgrundlag", false, NodeType.NORMAL);
    _addVertex("Pensionsselskabs info", "Beregningsgrundlag", false, NodeType.NORMAL);

    _addVertex("Beregningsgrundlag", "Beregningsgrundlag", true, NodeType.RESOLUTION);

    _addEdge("Udmaaling","Indkomstoplysninger");
    _addEdge("Udmaaling","Skatteoplysninger");
    _addEdge("Udmaaling","Pensionsoplysninger");

    _addEdge("Indkomstoplysninger", "Beregning af ydelse");
    _addEdge("Skatteoplysninger", "Beregning af ydelse");
    _addEdge("Pensionsoplysninger", "Beregning af ydelse");
    _addEdge("Pensionsoplysninger", "Pensionsselskabs info");

    _addEdge("Beregning af ydelse", "Beregningsgrundlag");
    _addEdge("Pensionsselskabs info", "Beregningsgrundlag");
  }

  function udbetaling() private {
    _addVertex("Borgerdokumentation", "Udbetaling", false, NodeType.DOC);
    _addVertex("Udbetaling", "Udbetaling", true, NodeType.RESOLUTION);

    _addEdge("Beregningsgrundlag","Borgerdokumentation");
    _addEdge("Borgerdokumentation","Udbetaling");
    _addEdge("Udbetaling", end);
  }
}

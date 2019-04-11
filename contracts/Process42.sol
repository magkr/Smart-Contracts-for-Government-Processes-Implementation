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
    udbetaling();
    resolvingResolution = "Beregningsgrundlag";

    /* test();
    resolvingResolution = "Resolution"; */
  }

  function metering() private {
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

  function test() private {
    _addVertex("Normal","Resolution", false);
    _addVertex("Resolution", "Resolution", true);
    _addVertex("Final", "Final", true);


    _addEdge(root,"Normal");
    _addEdge("Normal","Resolution");

    _addEdge("Resolution","Final");
    _addEdge("Final",end);

  }

  function beregningsgrundlag() private {
    _addVertex("Indkomstoplysninger", "Beregningsgrundlag", false);
    _addVertex("Skatteoplysninger", "Beregningsgrundlag", false);
    _addVertex("Pensionsoplysninger", "Beregningsgrundlag", false);

    _addVertex("Beregning af ydelse", "Beregningsgrundlag", false);
    _addVertex("Pensionsselskabs info", "Beregningsgrundlag", false);

    _addVertex("Beregningsgrundlag", "Beregningsgrundlag", true);

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
    _addVertex("Borgerdokumentation", "Udbetaling", false);
    _addVertex("Udbetaling", "Udbetaling", true);

    _addEdge("Beregningsgrundlag","Borgerdokumentation");
    _addEdge("Borgerdokumentation","Udbetaling");
    _addEdge("Udbetaling", end);
  }
}

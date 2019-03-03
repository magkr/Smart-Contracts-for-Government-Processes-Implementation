pragma solidity ^0.5.0;

import {Graph} from "./Graph.sol";

library ProcessFactory {
  using Graph for Graph.Digraph;

  function metering(Graph.Digraph storage graph) public {
    bytes32 root = "root";
    graph.addVertex("Arbejdstider");
    graph.addVertex("Familieforhold");
    graph.addVertex("Arbejdsfleksibilitet");
    graph.addVertex("Bevilligede timer");
    graph.addVertex("Sparede udgifter");
    graph.addVertex("Udmåling afgørelse");

    graph.addEdge(root,"Arbejdstider");
    graph.addEdge(root,"Familieforhold");
    graph.addEdge(root,"Arbejdsfleksibilitet");

    graph.addEdge("Arbejdstider","Bevilligede timer");
    graph.addEdge("Arbejdstider","Sparede udgifter");
    graph.addEdge("Familieforhold","Bevilligede timer");
    graph.addEdge("Familieforhold","Sparede udgifter");
    graph.addEdge("Arbejdsfleksibilitet","Bevilligede timer");
    graph.addEdge("Arbejdsfleksibilitet","Sparede udgifter");
    graph.addEdge("Bevilligede timer", "Udmåling afgørese");
    graph.addEdge("Sparede udgifter", "Udmåling afgørese");

  }

  function beregningsgrundlag(Graph.Digraph storage graph) public {
    bytes32 root = "Udmåling afgørese";
    graph.addVertex("Indkomstoplysninger");
    graph.addVertex("Skatteoplysninger");
    graph.addVertex("Pensionsoplysninger");

    graph.addVertex("Beregning af ydelse");
    graph.addVertex("Pensionsselskabs info");

    graph.addVertex("Beregningsgrundlag afgørelse");

    graph.addEdge(root,"Indkomstoplysninger");
    graph.addEdge(root,"Skatteoplysninger");
    graph.addEdge(root,"Pensionsoplysninger");

    graph.addEdge("Indkomstoplysninger", "Beregning af ydelse");
    graph.addEdge("Skatteoplysninger", "Beregning af ydelse");
    graph.addEdge("Pensionsoplysninger", "Beregning af ydelse");
    graph.addEdge("Pensionsoplysninger", "Pensionsselskabs info");

    graph.addEdge("Beregning af ydelse", "Beregningsgrundlag afgørelse");
    graph.addEdge("Pensionsselskabs info", "Beregningsgrundlag afgørelse");
  }

}

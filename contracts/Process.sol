pragma solidity ^0.5.0;

import {Graph} from "./Graph.sol";
import {ProcessFactory} from "./ProcessFactory.sol";

contract Process {
  using Graph for Graph.Digraph;

  Graph.Digraph graph;

  constructor() public {
    graph.init();
    ProcessFactory.metering(graph);
    ProcessFactory.beregningsgrundlag(graph);
  }

  /* function test() public view returns (bytes32[] memory) {
    uint[] memory adj = graph.vertxs[0].adj;
    uint length = adj.length;
    bytes32[] memory res = new bytes32[](length);
    for (uint i = 0; i < length; i++) {
      res[i] = graph.vertxs[adj[i]].title;
    }
    return res;
  } */

  function test() public returns (bytes32[] memory) {
    uint caseID = 0;
    graph.addCase(caseID);

    graph.setStatus("Arbejdstider", caseID, Graph.Status.DONE);
    graph.setStatus("Familieforhold", caseID, Graph.Status.DONE);
    graph.setStatus("Arbejdsfleksibilitet", caseID, Graph.Status.DONE);
    graph.setStatus("Bevilligede timer", caseID, Graph.Status.DONE);
    graph.setStatus("Sparede udgifter", caseID, Graph.Status.DONE);
    graph.setStatus("Udmåling afgørelse", caseID, Graph.Status.DONE);

    bytes32[] memory toDo = graph.getActions(caseID);
    return toDo;
  }

  /* struct Data {
    bytes32 title;
    bool done;
    uint[] documents;
  }

  struct Edge {
    bytes32 from;
    bytes32 to;
  }

  mapping (bytes32 => Data) public datas;

  Edge[] public edges;

  constructor() public {
    _addData("root");
    datas["root"].done = true;
  }

  function _addData(bytes32 _title) {
    datas[_title] = Data(_title, false, new uint[](0));
  }

  function _addEdge(bytes32 from, bytes32 to) {
    edges.push(Edge(from,to));
  } */

}

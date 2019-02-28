pragma solidity ^0.5.0;

import {Graph } from "./Graph.sol";

contract Process {
  using Graph for Graph.Digraph;

  Graph.Digraph graph;

  constructor() public {
    graph.createDigraph();
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

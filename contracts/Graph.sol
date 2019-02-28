pragma solidity ^0.5.0;

library Graph {

  struct Digraph {
    uint V;
    uint E;
    Vertex[] vertxs;
    mapping (bytes32 => uint) titleToID;

  }

  struct Vertex {
  	bytes32 title;
    uint[] adj;
  	uint tokensRequired;
  	mapping (uint => uint) caseTokenCounters;
  }

  function createDigraph(Digraph storage self) public
  {
    self.V = 0;
    self.E = 0;
    self.vertxs = new Vertex[](0);
  }

  function getV(Digraph storage self) public view returns (uint) { return self.V; }
  function getE(Digraph storage self) public view returns (uint) { return self.E; }
  function getAdj(Digraph storage self, uint v) public view returns (uint[] memory)
  { return self.vertxs[v].adj; }

  function addEdge(Digraph storage self, bytes32 v, bytes32 w) public {
    addEdgeByID(self, self.titleToID[v], self.titleToID[w]);
  }

  function addEdgeByID(Digraph storage self, uint v, uint w) private
  {
    self.vertxs[v].adj.push(w);
    self.E++;
  }

  function isReady(bytes32 title, uint caseID) public {

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

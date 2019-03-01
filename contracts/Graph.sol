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
    mapping (uint => uint) caseToTokens;
  }

  function init(Digraph storage self) public
  {
    self.V = 0;
    self.E = 0;
    self.vertxs.push(Vertex("root", new uint[](0), 0));
  }

  function addVertex(Digraph storage self, bytes32 title) public {
    self.titleToID[title] = self.V;
    self.vertxs.push(Vertex(title, new uint[](0), 0));
    self.V++;
  }

  function getAdj(Digraph storage self, bytes32 v) public view returns (uint[] memory)
  { return self.vertxs[self.titleToID[v]].adj; }

  function addEdge(Digraph storage self, bytes32 v, bytes32 w) public {
    addEdgeByID(self, self.titleToID[v], self.titleToID[w]);
  }

  function addEdgeByID(Digraph storage self, uint v, uint w) public
  {
    self.vertxs[v].adj.push(w);
    self.vertxs[w].tokensRequired++;
    self.E++;
  }

  function isReady(Digraph storage self, bytes32 title, uint caseID) public view returns (bool){
    uint id = self.titleToID[title];
    return isReadyByID(self, id, caseID);
  }

  function isReadyByID(Digraph storage self, uint id, uint caseID) public view returns (bool){
    Vertex storage v = self.vertxs[id];
    uint tokens = v.caseToTokens[caseID];
    return (tokens == v.tokensRequired);
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

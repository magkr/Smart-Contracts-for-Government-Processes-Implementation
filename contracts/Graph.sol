pragma solidity ^0.5.0;

library Graph {

  enum Status { DONE, UNDONE, MARKED }
  struct Digraph {
    Vertex[] vertxs;
    mapping (bytes32 => uint) titleToID;
  }

  struct Vertex {
  	bytes32 title;
    uint[] adj;
    uint[] req;
    mapping (uint => Status) status;
    //mapping (uint => data) datas;
  }

  /* struct Data {
    uint addr;
    uint[] datas;
  } */

  function init(Digraph storage self) public
  {
    addVertex(self, "root");
  }

  function addVertex(Digraph storage self, bytes32 title) public {
    self.titleToID[title] = self.vertxs.length;
    self.vertxs.push(Vertex(title, new uint[](0), new uint[](0)));
  }

  function getAdj(Digraph storage self, bytes32 v) public view returns (uint[] memory)
  { return self.vertxs[self.titleToID[v]].adj; }

  function addEdge(Digraph storage self, bytes32 v, bytes32 w) public {
    addEdgeByID(self, self.titleToID[v], self.titleToID[w]);
  }

  function addEdgeByID(Digraph storage self, uint v, uint w) public
  {
    self.vertxs[v].adj.push(w);
    self.vertxs[w].req.push(v);
  }

  function setStatus(Digraph storage self, bytes32 title, uint caseID, Status status) public {
    uint id = self.titleToID[title];
    Vertex storage v = self.vertxs[id];
    v.status[caseID] = status;
  }

  function addCase(Digraph storage self, uint caseID) public {
    for(uint i = 0; i < self.vertxs.length; i++) {
      self.vertxs[i].status[caseID] = Status.UNDONE;
    }
    setStatus(self, "root", caseID, Status.DONE);
  }

  function getActions(Digraph storage self, uint caseID) public returns (bytes32[] memory) {
    Vertex[] storage vs = self.vertxs;
    bytes32[] memory toDo = new bytes32[](vs.length);
    uint count = 0;

    for (uint i = 0; i < vs.length; i++) {
      if (isUndone(self, i, caseID)) {
        bool isReady = true;

        for(uint j = 0; j < vs[i].req.length; j++) {
          if (isUndone(self, vs[i].req[j], caseID)) { isReady = false; }
        }

        if (isReady) {
          toDo[count] = vs[i].title;
          count++;
        }
      }
    }

    return cut(toDo, count);
  }

  function isUndone(Digraph storage self, uint v, uint caseID) public returns (bool) {
    return (self.vertxs[v].status[caseID] == Status.UNDONE);
  }

  function cut(bytes32[] memory arr, uint count) public returns (bytes32[] memory) {
    bytes32[] memory res = new bytes32[](count);
    for (uint i = 0; i < count; i++) { res[i] = arr[i]; }
    return res;
  }

  /* function getActions(Digraph storage self, uint caseID) public returns () {
    Vertex[] storage vs = self.vertxs;
    Vertex[] memory toDo = self.vertxs;
    int counter = self.vertxs.length;


    for (uint i = 0; i < vs.length; i++) {
      if (toDo[i] && vs[i].status[caseID] == Status.DONE) {
        delete toDo[i];
        counter--;
      } else {
        for(uint j = 0; j < vs[i].adj.length; j++) {
          uint adj = vs[i].adj[j];
          if (toDo[adj]) {
            delete toDo[adj];
            counter--;
          }
        }
      }
    }

    Vertex[] memory toDo = Vertex[](counter);
    for (uint i = 0; i < vs.length; i++) {
      if (toDo[i]) {

      }
    }
  } */

  /* function isReady(Digraph storage self, bytes32 title, uint caseID) public view returns (bool){

  }

  function isReadyByID(Digraph storage self, uint id, uint caseID) public view returns (bool){

  } */


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

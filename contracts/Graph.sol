pragma solidity 0.5.0;

import {IterableMap} from "./IterableMap.sol";

library Graph {
  using IterableMap for IterableMap.Map;

  enum Status { DONE, UNDONE, MARKED, PENDING }
  /* struct Data { bytes32 title; } */

  struct Digraph {
    Vertex[] vertxs;
    mapping (bytes32 => uint) titleToIDs;
  }

  struct Vertex {
  	bytes32 title;
    uint[] adj;
    uint[] req;
    mapping (uint => Status) status;
  }

  /* Vertex[] vertxs;                               // REMAKE GRAPH
  mapping (bytes32 => uint) titleToIDs;  */         // REMAKE GRAPH

  function init(Digraph storage self) public {
    addVertex(self, "root");
  }

  function getID(Digraph storage self, bytes32 title) private view returns (uint id) {
    // if v doesn't exist, throw error
    return self.titleToIDs[title];
  }

  function addVertex(Digraph storage self, bytes32 title) public returns (bool) {
    // if title exists, throw error
    self.titleToIDs[title] = self.vertxs.length;
    self.vertxs.push(Vertex(title, new uint[](0), new uint[](0)));
    return true;
  }

  function addEdge(Digraph storage self, bytes32 from, bytes32 to) public returns (bool) {
    // if v or w doesn't exist, throw error
    uint v = getID(self, from);
    uint w = getID(self, to);

    if (v < 0 || v >= self.vertxs.length || w < 0 || w >= self.vertxs.length) return false;

    self.vertxs[v].adj.push(w);
    self.vertxs[w].req.push(v);
    return true;
  }

  function mark(Digraph storage self, bytes32 title, uint caseID) public returns (bool) {
    // if title or case doesn't exist, throw error

    /*
    setStatus(self, title, caseID, Status.MARKED);
    _cascadeMark(self, getID(self, title), caseID); */

    uint[] memory pendingvs = new uint[](self.vertxs.length);
    uint counter = 0;

    setStatus(self, title, caseID, Status.MARKED);

    pendingvs[counter] = getID(self, title);
    counter++;

    uint pending;
    while(counter > 0) {
      pending = pendingvs[counter];
      counter--;

      for (uint i = 0; i < self.vertxs[pending].adj.length; i++ ) {
        uint adj = self.vertxs[pending].adj[i];
        if (_status(self, adj, caseID, Status.DONE)) {
          self.vertxs[adj].status[caseID] = Status.PENDING;
          pendingvs[counter] = adj;
          counter++;
        }
      }
    }
    return true;

    /*
    vs[]
    v;
    while (vs.length > 0 || )
      foreach( adj in v.adj )
          if adj == done then
            adj = pending
            vs.push(adj)
      v = vs.pop();
    */
  }

  /* function _cascadeMark(Digraph storage self, uint _v, uint caseID) private {
    Vertex storage v = self.vertxs[_v];
    for(uint i = 0; i < v.adj.length; i++) {
      uint adj = v.adj[i];
      if (_status(self, adj, caseID, Status.DONE)) {
        self.vertxs[adj].status[caseID] = Status.PENDING;
        _cascadeMark(self, adj, caseID);
      }
    }

  } */

  function unmark(Digraph storage self, bytes32 title, uint caseID) public returns (bool) {
    // if title or case doesn't exist, throw error
    setStatus(self, title, caseID, Status.DONE);
    _cascadeUnmark(self, getID(self, title), caseID);
  }

  function _cascadeUnmark(Digraph storage self, uint _v, uint caseID) private {
    Vertex storage v = self.vertxs[_v];
    for(uint i = 0; i < v.adj.length; i++) {
      uint adj = v.adj[i];
      if (_status(self, adj, caseID, Status.PENDING)) {
        self.vertxs[adj].status[caseID] = Status.DONE;
        _cascadeUnmark(self, adj, caseID);
      }
    }
  }

  function setStatus(Digraph storage self, bytes32 title, uint caseID, Status status) public {
    // if title or case doesn't exist, throw error
    Vertex storage v = self.vertxs[getID(self, title)];
    /* if (status == Status.MARKED) {
      if (v.status[caseID] == Status.DONE) {
        cascade(self, v, caseID);
      }
    }
    else  */
    v.status[caseID] = status;
  }

  /* function mark(Digraph storage self, bytes32 title, uint caseID, Status status) public {
    self.vertxs[getID(title, caseID)];
  } */

  function addCase(Digraph storage self, uint caseID) public {
    // if case exist, throw error
    for(uint i = 0; i < self.vertxs.length; i++) {
      self.vertxs[i].status[caseID] = Status.UNDONE;
    }
    setStatus(self, "root", caseID, Status.DONE);
  }

  function getActions(Digraph storage self, uint caseID) public view returns (bytes32[] memory) {
    // if case doesnt exist, throw error
    bytes32[] memory toDo = new bytes32[](self.vertxs.length);
    uint count = 0;

    for (uint v = 0; v < self.vertxs.length; v++) {
      if (_isReady(self, v, caseID)) {
        toDo[count] = self.vertxs[v].title;
        count++;
      }
    }

    return cut(toDo, count);
  }

  function _isReady(Digraph storage self, uint v, uint caseID) private view returns (bool) {
    // if v doesnt exist, throw error
    Vertex[] storage vs = self.vertxs;
    if (_status(self, v, caseID, Status.DONE)) return false;

    for(uint j = 0; j < vs[v].req.length; j++) {
      if (!_status(self, vs[v].req[j], caseID, Status.DONE)) return false;
    }

    return true;
  }
  function ready(Digraph storage self, bytes32 title, uint caseID) public view returns (bool) {
    return _isReady(self, getID(self, title), caseID);
  }

  function _status(Digraph storage self, uint v, uint caseID, Status status) private view returns (bool) {
    return (self.vertxs[v].status[caseID] == status);
  }

  function getStatus(Digraph storage self,bytes32 title, uint caseID) public view returns (Status) {
    return self.vertxs[getID(self, title)].status[caseID];
  }

  function _statusByTitle(Digraph storage self, bytes32 title, uint caseID, Status status) private view returns (bool) {
    if (getID(self, title) == 0 && title != "root") return false;
    return (self.vertxs[getID(self, title)].status[caseID] == status);
  }

  function done(Digraph storage self, bytes32 title, uint caseID) public view returns (bool) {
    return _statusByTitle(self, title, caseID, Status.DONE);
  }

  function undone(Digraph storage self, bytes32 title, uint caseID) public view returns (bool) {
    return _statusByTitle(self, title, caseID, Status.UNDONE);
  }

  function marked(Digraph storage self, bytes32 title, uint caseID) public view returns (bool) {
    return _statusByTitle(self, title, caseID, Status.MARKED);
  }

  function pending(Digraph storage self, bytes32 title, uint caseID) public view returns (bool) {
    return _statusByTitle(self, title, caseID, Status.PENDING);
  }


  function cut(bytes32[] memory arr, uint count) public pure returns (bytes32[] memory) {
    bytes32[] memory res = new bytes32[](count);
    for (uint i = 0; i < count; i++) { res[i] = arr[i]; }
    return res;
  }

  /* function getActions(Digraph storage self, uint caseID) public returns (bytes32[] memory) {
    Vertex[] memory vs = self.vertxs;
    bool[] memory isReady = bool[](self.vertxs.length);

    for (uint i = 0; i < vs.length; i++) {
      isReady = true;
    }

    for (uint i = 0; i < vs.length; i++) {
      if()
      Vertex storage v = self.vertxs[i];
      if (!isRemoved(vs[i]) && (v.status[caseID] == Status.UNDONE)) {
        vs = remove(self, vs, i);
      }
    }

    uint count = 0;
    for (uint i = 0; i < vs.length; i++) {
      if (!isRemoved(vs[i])) count++;
    }

    return collect(vs, count);
  }

  function remove(Digraph storage self, Vertex[] memory vs, uint vid) private returns (Vertex[] memory) {
    Vertex storage v = self.vertxs[vid];
    for(uint i = 0; i < v.adj.length; i++) {
      uint adj = v.adj[i];
      if (!isRemoved(vs[adj])) {
        vs[adj].title = "removed";
        vs = remove(self, vs, adj);
      }
    }
    return vs;
  }

  function isRemoved(Vertex memory v) private returns(bool) {
    return (v.title == "removed");
  }

  function collect(Vertex[] memory vs, uint count) private returns (bytes32[] memory titles){
    bytes32[] memory toDo = new bytes32[](count);
    uint c = 0;
    for (uint i = 0; i < vs.length; i++) {
      if (!isRemoved(vs[i])) {
        toDo[c] = vs[i].title;
        c++;
      }
    }
    return toDo;
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

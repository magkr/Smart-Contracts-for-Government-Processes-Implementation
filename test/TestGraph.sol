pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import { Graph } from "../contracts/Graph.sol";

contract TestGraph {
  /* Graph.Digraph private _graph;
  bytes32 t = "test";
  bytes32 r = "root";
  uint caseID = 12;
  Graph.Status st_DONE = Graph.Status.DONE;
  Graph.Status st_UNDONE = Graph.Status.UNDONE;
  Graph.Status st_MARKED = Graph.Status.MARKED;

  function getVertexFromTitle(bytes32 _t) private returns (uint) {
    return _graph.vertxs[_graph.titleToID[_t]];
  }

  function testInit() public {
    //Arrange

    //Act
    Graph.init(_graph);

    //Assert
    Assert.equal(_graph.vertxs[0].title, r, "root is added in init");
  }

  function testAddVertex() public {
    //Arrange

    //Act
    Graph.addVertex(_graph, t);

    //Assert
    Assert.equal(_graph.vertxs[1].title, t, "vertex is added correctly in array");
    Assert.equal(_graph.titleToID[t], 1, "vertex is added correctly in mapping");
  }

  function testAddEdge() public {
    //Arrange
    bytes32 t1 = "test1";
    bytes32 t2 = "test2";
    Graph.addVertex(_graph, t1);
    Graph.addVertex(_graph, t2);

    //Act
    Graph.addEdge(_graph, "test1", "test2");

    //Assert
    Assert.equal(getVertexFromTitle(t1).adj[0].title, "test2", "correctly added as adjacent");
    Assert.equal(getVertexFromTitle(t2).adj[0].title, "test1", "correctly added as required");
  }

  function testSetStatus() public {
    //Arrange
    Graph.addVertex(_graph, t);
    Graph.addCase(_graph, caseID);

    //Act
    Graph.setStatus(_graph, t, caseID, st_MARKED);

    //Assert
    Assert.isTrue(getVertexFromTitle(t).status == st_MARKED, "status is set corretly");
  }

  function testAddCase() public {
    //Arrange
    Graph.addVertex(_graph, t);
    //Act
    Graph.addCase(_graph, caseID);

    //Assert
    Assert.isTrue(getVertexFromTitle(t).status == st_UNDONE, "status for nonroot is set corretly");
    Assert.isTrue(getVertexFromTitle(r).status == st_DONE, "status for root is set corretly");
  }

  function testIsUndone() public {
    //Arrange
    Graph.addVertex(_graph, t);
    Graph.addCase(_graph, caseID);

    //Act
    bool res1 = Graph.undone(_graph, getVertexFromTitle(t), caseID);
    bool res2 = Graph.undone(_graph, getVertexFromTitle(r), caseID);

    //Assert
    Assert.isTrue(res1, "is UNDONE with for nonroot");
    Assert.isFalse(res2, "is DONE with for root");
  }


  function testCut() public {
    //Arrange
    uint oldLength = 8;
    bytes32[] memory arr = new bytes32[](oldLength);
    for(uint i = 0; i < oldLength; i++) {
      arr[i] = bytes32(i);
    }
    uint newLength = 6;

    //Act
    bytes32[] memory res = Graph.cut(arr, newLength);

    //Assert
    Assert.equal(res.length, newLength, "returned array has new length");
    for(uint i = 0; i < newLength; i++) {
      Assert.equal(arr[i], bytes32(i), "returned array has correct value at index: " + i);
    }
  } */

}

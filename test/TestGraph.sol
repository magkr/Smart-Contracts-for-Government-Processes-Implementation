pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Graph.sol";
import "../contracts/Process.sol";



contract TestGraph {
  using Graph for Graph.Digraph;
  using IterableMap for IterableMap.Map;

  Graph.Digraph graph;

  constructor() public {
    graph.init();

    graph.addVertex("a");
    graph.addVertex("ba");
    graph.addVertex("bb");
    graph.addVertex("c");

    graph.addEdge("root", "a");
    graph.addEdge("a", "ba");
    graph.addEdge("a", "bb");
    graph.addEdge("ba", "c");
    graph.addEdge("bb", "c");

    graph.addCase(0);
  }

  function testAddCase() public { // FEJLER!!!
    bool isDone = (graph.getStatus("root", 0) == Graph.Status.DONE);
    bool isUndone = (graph.getStatus("a", 0) == Graph.Status.UNDONE);
    Assert.equal(isDone, true, "root has been set to DONE");
    Assert.equal(isUndone, true, "a has been set to UNDONE");
  }

  function testReady() public {
    bool aReady = graph.ready("a", 0);
    bool baReady = graph.ready("ba", 0);
    Assert.equal(aReady, true, "a should be ready");
    Assert.equal(baReady, false, "ba should not be ready");
  }

  function testSetStatus() public {
    bool pre = (graph.getStatus("a", 0) == Graph.Status.UNDONE);

    graph.setStatus("a", 0, Graph.Status.DONE);
    bool post = (graph.getStatus("a", 0) == Graph.Status.DONE);

    graph.setStatus("a", 0, Graph.Status.UNDONE);
    bool setback = (graph.getStatus("a", 0) == Graph.Status.UNDONE);

    Assert.equal(pre, true, "a before should be undone");
    Assert.equal(post, true, "a after should be done");
    Assert.equal(setback, true, "a should be set back to undone");
  }

  function testUndone() public {
    bool isUndone = graph.undone("ba", 0);
    Assert.equal(isUndone, true, "undone ba should return true");
  }

  function testDone() public {
    bool isDone = graph.done("root", 0);
    Assert.equal(isDone, true, "done a should return true");
  }

  function testMarked() public {
    bool pre = graph.marked("ba", 0);
    graph.setStatus("ba", 0, Graph.Status.MARKED);
    bool post = graph.marked("ba", 0);
    graph.setStatus("ba", 0, Graph.Status.UNDONE);
    bool setback = graph.undone("ba", 0);

    Assert.equal(pre, false, "marked pre should return false");
    Assert.equal(post, true, "marked post should return true");
    Assert.equal(setback, true, "ba should be set back to undone");
  }

  function testPending() public {
    bool pre = graph.pending("ba", 0);
    graph.setStatus("ba", 0, Graph.Status.PENDING);
    bool post = graph.pending("ba", 0);
    graph.setStatus("ba", 0, Graph.Status.UNDONE);
    bool setback = graph.undone("ba", 0);

    Assert.equal(pre, false, "pending pre should return false");
    Assert.equal(post, true, "pending post should return true");
    Assert.equal(setback, true, "ba should be set back to undone");
  }

  function testOnNonExistingVertex() public {
    bool isDone = graph.done("root", 0);
    bool fail = graph.done("fail", 0);

    Assert.equal(isDone, true, "done on root should return true");
    Assert.equal(fail, false, "done on non-existing vertex should return false");
  }


  function testCut() public {
    bytes32[] memory toDo = new bytes32[](3);
    toDo[0] = "a";
    toDo[1] = "b";
    toDo[2] = "c";
    bytes32[] memory res = Graph.cut(toDo, 2);

    Assert.equal(res.length, 2, "res[0] should be a");
    Assert.equal(res[0], "a", "res[0] should be a");
    Assert.equal(res[1], "b", "res[1] should be a");
  }

  /* function testProcessFillSuccessfull() public {
    bool success = fill("ba", 0);
    Assert.equal(success, true, "fill ba should be successful");

    bool done = (graph.done("a", 0));
    Assert.equal(done, true, "a should be DONE");

    done = (graph.done("ba", 0));
    Assert.equal(done, true, "ba should be DONE");

    done = (graph.undone("bb", 0));
    Assert.equal(done, true, "bb should be UNDONE");

    done = (graph.undone("c", 0));
    Assert.equal(done, true, "c should be UNDONE");
  }

  function testProcessFillFails() public {
    this.fill("ba", 0);

    bool success = this.fill("c", 0);
    Assert.equal(success, false, "fill c should be unsuccessful");

    bool done = (graph.done("a", 0));
    Assert.equal(done, true, "a should be DONE");

    done = (graph.done("ba", 0));
    Assert.equal(done, true, "ba should be DONE");

    done = (graph.undone("bb", 0));
    Assert.equal(done, true, "bb should be UNDONE");

    done = (graph.undone("c", 0));
    Assert.equal(done, true, "c should be UNDONE");
  }

  function testProcessMark() public {

    this.fill("ba", 0);
    this.fill("bb", 0);
    this.mark("a", 0);

    bool success = this.fill("c", 0);
    Assert.equal(success, false, "fill c should be unsuccessful");

    bool done = (graph.done("a", 0));
    Assert.equal(done, true, "a should be DONE");

    done = (graph.done("ba", 0));
    Assert.equal(done, true, "ba should be DONE");

    done = (graph.undone("bb", 0));
    Assert.equal(done, true, "bb should be UNDONE");

    done = (graph.undone("c", 0));
    Assert.equal(done, true, "c should be UNDONE");
  } */






  /* function testProcessMark() public {
    Process process = Process(DeployedAddresses.Process());
    process.smallTestSetup();

    process.mark("a", 0);

    Assert.equal(graph.marked("a", 0), true, "actions.length should be 2");
    Assert.equal(graph.pending("ba", 0), true, "actions[0] should be ba");
    Assert.equal(titles[1], "bb", "actions[1] should be bb");
  } */


  /* function testMarkingCascades() public {
    Process process = Process(DeployedAddresses.Process());
    process.smallTestSetup();

    process.fill("ba");

    Assert.equal(true, true, "process.mark(a) should return true");

  } */


}

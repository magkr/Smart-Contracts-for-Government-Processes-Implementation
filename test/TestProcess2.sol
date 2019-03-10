pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Process.sol";
import "../contracts/Graph.sol";


contract TestProcess2 is Process {
  using Graph for Graph.Digraph;

  constructor() public {
    graph.addVertex("a");
    graph.addVertex("ba");
    graph.addVertex("bb");
    graph.addVertex("c");
    graph.addVertex("d");
    graph.addVertex("e");

    graph.addEdge("root", "a");
    graph.addEdge("a", "ba");
    graph.addEdge("a", "bb");
    graph.addEdge("ba", "c");
    graph.addEdge("c", "end");

    graph.addEdge("ba", "d");
    graph.addEdge("d", "e");
    graph.addEdge("e", "end");

    graph.addCase(0);
  }

  function testSetup() public {
    bool hasRoot = graph.done("root", 0);
    bool a = graph.undone("a", 0);
    bool ba = graph.undone("ba", 0);
    bool bb = graph.undone("bb", 0);
    bool c = graph.done("c", 0);
    bool fail = graph.undone("x", 0);

    Assert.equal(hasRoot, true, "has root = true");
    Assert.equal(a, true, "a is undone");
    Assert.equal(ba, true, "ba is undone");
    Assert.equal(bb, true, "bb is undone");
    Assert.equal(c, false, "c is undone");
    Assert.equal(fail, false, "x is false");
  }

  function testGetActions() public {
    bytes32[] memory titles = getActions(0);
    graph.setStatus("a", 0, Graph.Status.DONE);
    bytes32[] memory titles2 = getActions(0);
    graph.setStatus("a", 0, Graph.Status.UNDONE);

    Assert.equal(titles.length, 1, "actions.length should be 1");
    Assert.equal(titles[0], "a", "actions[0] should be a");
    Assert.equal(titles2.length, 2, "actions.length should be 2");
    Assert.equal(titles2[0], "ba", "actions[0] should be ba");
    Assert.equal(titles2[1], "bb", "actions[1] should be bb");
  }

  function testMarkSuceed() public {
    fill("a", 0);
    fill("ba", 0);
    fill("d", 0);
    fill("e", 0);

    bool success = mark("a", 0);
    Assert.equal(success, true, "mark a should be successful");

    bool status = graph.marked("a", 0);
    Assert.equal(status, true, "a should be MARKED");

    status = graph.pending("ba", 0);
    Assert.equal(status, true, "ba should be PENDING");

    status = graph.pending("d", 0);
    Assert.equal(status, true, "bb should be PENDING");

    status = graph.pending("e", 0);
    Assert.equal(status, true, "c should be PENDING");

    status = graph.undone("bb", 0);
    Assert.equal(status, true, "ba should be UNDONE");

    status = graph.undone("c", 0);
    Assert.equal(status, true, "ba should be UNDONE");
  }

  //TESTING METHOD 2:

  function testFillSucceeds() public {
    Process process = Process(DeployedAddresses.Process());
    process.smallTestSetup();

    bool success = process.fill("ba", 0);
    Assert.equal(success, true, "fill ba should be successful");

    bool done = (process.getStatus("a", 0) == Graph.Status.DONE);
    Assert.equal(done, true, "a should be DONE");

    done = (process.getStatus("ba", 0) == Graph.Status.DONE);
    Assert.equal(done, true, "ba should be DONE");

    done = (process.getStatus("bb", 0) == Graph.Status.UNDONE);
    Assert.equal(done, true, "bb should be UNDONE");

    done = (process.getStatus("c", 0) == Graph.Status.UNDONE);
    Assert.equal(done, true, "c should be UNDONE");
  }

  function testFillFails() public {
    Process process = Process(DeployedAddresses.Process());
    process.smallTestSetup();
    process.fill("ba", 0);

    bool success = process.fill("c", 0);
    Assert.equal(success, false, "fill c should be unsuccessful");

    bool done = (process.getStatus("a", 0) == Graph.Status.DONE);
    Assert.equal(done, true, "a should be DONE");

    done = (process.getStatus("ba", 0) == Graph.Status.DONE);
    Assert.equal(done, true, "ba should be DONE");

    done = (process.getStatus("bb", 0) == Graph.Status.UNDONE);
    Assert.equal(done, true, "bb should be UNDONE");

    done = (process.getStatus("c", 0) == Graph.Status.UNDONE);
    Assert.equal(done, true, "c should be UNDONE");
  }

  function testMarkingSucceed() public {
    Process process = Process(DeployedAddresses.Process());
    process.smallTestSetup();
    process.fill("ba", 0);
    process.fill("bb", 0);
    process.fill("c", 0);

    bool success = process.mark("a", 0);
    Assert.equal(success, true, "mark a should be successful");

    bool status = (process.getStatus("a", 0) == Graph.Status.MARKED);
    Assert.equal(status, true, "a should be MARKED");

    status = (process.getStatus("ba", 0) == Graph.Status.PENDING);
    Assert.equal(status, true, "ba should be PENDING");

    status = (process.getStatus("bb", 0) == Graph.Status.PENDING);
    Assert.equal(status, true, "bb should be PENDING");

    status = (process.getStatus("c", 0) == Graph.Status.PENDING);
    Assert.equal(status, true, "c should be PENDING");
  }

  function testMarkingFails() public {
    Process process = Process(DeployedAddresses.Process());
    process.smallTestSetup();

    bool success = process.mark("ba", 0);
    Assert.equal(success, false, "mark ba should be unsuccessful");

    bool status = (process.getStatus("a", 0) == Graph.Status.DONE);
    Assert.equal(status, true, "a should be DONE");

    status = (process.getStatus("ba", 0) == Graph.Status.UNDONE);
    Assert.equal(status, true, "ba should be UNDONE");

    status = (process.getStatus("bb", 0) == Graph.Status.UNDONE);
    Assert.equal(status, true, "bb should be UNDONE");

    status = (process.getStatus("c", 0) == Graph.Status.UNDONE);
    Assert.equal(status, true, "c should be UNDONE");
  }


}

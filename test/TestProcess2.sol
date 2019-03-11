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

  function testFillSuceed() public {
    bool success = fill("a", 0);
    uint actions = getActions(0).length;

    bool a = graph.done("a", 0);
    bool ba = graph.undone("ba", 0);
    bool bb = graph.undone("bb", 0);
    bool c = graph.undone("c", 0);

    Assert.equal(success, true, "fill a should be successful");
    Assert.equal(actions, 2, "actions.length should be 2 (ba and bb)");
    Assert.equal(a, true, "a should be DONE");
    Assert.equal(ba, true, "ba should be UNDONE");
    Assert.equal(bb, true, "bb should be UNDONE");
    Assert.equal(c, true, "c should be UNDONE");
  }

  function testMarkSuceed() public {
    fill("a", 0);
    fill("ba", 0);
    fill("d", 0);
    fill("e", 0);

    bool success = mark("a", 0);
    bool a = graph.marked("a", 0);
    bool ba = graph.pending("ba", 0);
    bool d = graph.pending("d", 0);
    bool e = graph.pending("e", 0);
    bool bb = graph.undone("bb", 0);
    bool c = graph.undone("c", 0);

    Assert.equal(success, true, "mark a should be successful");
    Assert.equal(a, true, "a should be MARKED");
    Assert.equal(ba, true, "ba should be PENDING");
    Assert.equal(d, true, "d should be PENDING");
    Assert.equal(e, true, "e should be PENDING");
    Assert.equal(bb, true, "vv should be UNDONE");
    Assert.equal(c, true, "c should be UNDONE");

  }

  //TESTING METHOD 2:

  function testFillSucceeds() public {
    Process process = Process(DeployedAddresses.Process());
    process.smallTestSetup();

    bool success = process.fill("ba", 0);
    bool a = (process.getStatus("a", 0) == Graph.Status.DONE);
    bool ba = (process.getStatus("ba", 0) == Graph.Status.DONE);
    bool bb = (process.getStatus("bb", 0) == Graph.Status.UNDONE);
    bool c = (process.getStatus("c", 0) == Graph.Status.UNDONE);

    Assert.equal(success, true, "fill ba should be successful");
    Assert.equal(a, true, "a should be DONE");
    Assert.equal(ba, true, "ba should be DONE");
    Assert.equal(bb, true, "bb should be UNDONE");
    Assert.equal(c, true, "c should be UNDONE");

  }

  function testFillFails() public {
    Process process = Process(DeployedAddresses.Process());
    process.smallTestSetup();
    process.fill("ba", 0);

    bool success = process.fill("c", 0);
    bool a = (process.getStatus("a", 0) == Graph.Status.DONE);
    bool ba = (process.getStatus("ba", 0) == Graph.Status.DONE);
    bool bb = (process.getStatus("bb", 0) == Graph.Status.UNDONE);
    bool c = (process.getStatus("c", 0) == Graph.Status.UNDONE);

    Assert.equal(success, false, "fill c should be unsuccessful");
    Assert.equal(a, true, "a should be DONE");
    Assert.equal(ba, true, "ba should be DONE");
    Assert.equal(bb, true, "bb should be UNDONE");
    Assert.equal(c, true, "c should be UNDONE");

  }

  function testMarkingSucceed() public {
    Process process = Process(DeployedAddresses.Process());
    process.smallTestSetup();
    process.fill("ba", 0);
    process.fill("bb", 0);
    process.fill("c", 0);

    bool success = process.mark("a", 0);
    bool a = (process.getStatus("a", 0) == Graph.Status.MARKED);
    bool ba = (process.getStatus("ba", 0) == Graph.Status.PENDING);
    bool bb = (process.getStatus("bb", 0) == Graph.Status.PENDING);
    bool c = (process.getStatus("c", 0) == Graph.Status.PENDING);

    Assert.equal(success, true, "mark a should be successful");
    Assert.equal(a, true, "a should be MARKED");
    Assert.equal(ba, true, "ba should be PENDING");
    Assert.equal(bb, true, "bb should be PENDING");
    Assert.equal(c, true, "c should be PENDING");
  }

  function testMarkingFails() public {
    Process process = Process(DeployedAddresses.Process());
    process.smallTestSetup();

    bool success = process.mark("ba", 0);
    bool a = (process.getStatus("a", 0) == Graph.Status.DONE);
    bool ba = (process.getStatus("ba", 0) == Graph.Status.UNDONE);
    bool bb = (process.getStatus("bb", 0) == Graph.Status.UNDONE);
    bool c = (process.getStatus("c", 0) == Graph.Status.UNDONE);

    Assert.equal(success, false, "mark ba should be unsuccessful");
    Assert.equal(a, true, "a should be DONE");
    Assert.equal(ba, true, "ba should be UNDONE");
    Assert.equal(bb, true, "bb should be UNDONE");
    Assert.equal(c, true, "c should be UNDONE");
  }

  function testFillFailsOnMarked() public {
    Process process = Process(DeployedAddresses.Process());
    process.smallTestSetup();
    process.fill("a", 0);
    process.mark("a", 0);

    bool a = (process.getStatus("a", 0) == Graph.Status.MARKED);
    bool asuccess = process.fill("a", 0);
    bool aafter = (process.getStatus("a", 0) == Graph.Status.MARKED);

    Assert.equal(a, true, "a should be MARKED");
    Assert.equal(asuccess, false, "fill marked a should not succeed");
    Assert.equal(aafter, true, "a should still be MARKED");
  }

  function testFillFailsOnPending() public {
    Process process = Process(DeployedAddresses.Process());
    process.smallTestSetup();
    process.fill("a", 0);
    process.fill("ba", 0);
    process.mark("a", 0);

    bool ba = (process.getStatus("ba", 0) == Graph.Status.PENDING);
    bool bsuccess = process.fill("b", 0);
    bool baafter = (process.getStatus("ba", 0) == Graph.Status.PENDING);

    Assert.equal(ba, true, "ba should be PENDING");
    Assert.equal(bsuccess, false, "fill pending b should not succeed");
    Assert.equal(baafter, true, "ba should still be PENDING");
  }

  function testUnmarkSucceedOnMarked() public {
    Process process = Process(DeployedAddresses.Process());
    process.smallTestSetup();
    process.fill("a", 0);
    process.fill("ba", 0);
    process.mark("a", 0);

    bool success = process.unmark("a", 0);
    bool a = (process.getStatus("a", 0) == Graph.Status.DONE);
    bool ba = (process.getStatus("ba", 0) == Graph.Status.DONE);

    Assert.equal(success, true, "unmark a should succeed");
    Assert.equal(a, true, "a should be back to DONE");
    Assert.equal(ba, true, "ba should be back to DONE");
  }

  function testUnmarkFailsOnUndone() public {
    Process process = Process(DeployedAddresses.Process());
    process.smallTestSetup();

    bool success = process.unmark("ba", 0);
    bool ba = (process.getStatus("ba", 0) == Graph.Status.UNDONE);

    Assert.equal(success, false, "unmark undone ba should not succeed");
    Assert.equal(ba, true, "ba should still be UNDONE");
  }

  function testUnmarkWithSeveralMarks() public {
    Process process = Process(DeployedAddresses.Process());
    process.smallTestSetup(); // a -> (ba,bb) -> c -> d
    process.fill("a", 0);
    process.fill("ba", 0);
    process.fill("bb", 0);
    process.fill("c", 0);   // done - > (done,done) -> done -> undone
    /* process.mark("a", 0);   // marked - > (pending,pending) -> pending -> undone */
    /* process.mark("ba", 0);  // marked -> (marked,pending) -> pending */

    /* bool success = process.unmark("ba", 0); */
    bool ba = (process.getStatus("ba", 0) == Graph.Status.PENDING);
    bool c = (process.getStatus("c", 0) == Graph.Status.PENDING);

    /* Assert.equal(success, false, "unmark undone ba should not succeed"); */
    Assert.equal(ba, true, "ba should be set back to PENDING");
    Assert.equal(c, true, "c should still be PENDING");

  }
}

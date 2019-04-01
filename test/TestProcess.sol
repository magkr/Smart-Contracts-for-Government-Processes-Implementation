pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Process.sol";


contract TestProcess {
/*
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

    /* bool success = process.unmark("ba", 0); */ /*
    bool ba = (process.getStatus("ba", 0) == Graph.Status.PENDING);
    bool c = (process.getStatus("c", 0) == Graph.Status.PENDING);
*/
    /* Assert.equal(success, false, "unmark undone ba should not succeed"); *//*
    Assert.equal(ba, true, "ba should be set back to PENDING");
    Assert.equal(c, true, "c should still be PENDING");

  }*/
}

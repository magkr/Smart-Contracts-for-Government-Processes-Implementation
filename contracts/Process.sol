pragma solidity 0.5.0;


import {Graph} from "./Graph.sol";
import {ProcessFactory} from "./ProcessFactory.sol";

contract Process {
  using Graph for Graph.Digraph;

  Graph.Digraph graph;

  uint[] cases;

  /*  IDEAS FOR MAINTAING A STORAGE OF DATA
  mapping (bytes32 => DataTable) store;

  struct DataTable { mapping (uint => CaseData) caseEntry; }
  struct CaseData {
    uint location;
    uint dataHash;
  }

  mapping (bytes32 => Data) public datas;
 */


  constructor() public {
    graph.init();  
    ProcessFactory.metering(graph);
    ProcessFactory.beregningsgrundlag(graph);
  }

  function addCase() public {
    uint id = cases.length+1;
    cases.push(id);
    graph.addCase(id);
  }

  function getCases() public view returns (uint[] memory){
    return cases;
  }

  function getActions(uint caseID) public view returns (bytes32[] memory titles) {
    return graph.getActions(caseID);
  }

  function fill(bytes32 title, uint caseID) public returns (bool success) {
    if (!(graph.done(title, caseID) || graph.undone(title, caseID))) return false; //vertex either marked or pending
    if (!graph.ready(title, caseID)) return false;
    graph.setStatus(title, caseID, Graph.Status.DONE);
    return true;
  }

  function mark(bytes32 title, uint caseID) public returns (bool) {
    if (graph.done(title, caseID) || graph.pending(title, caseID)) {
      graph.mark(title, caseID);
      return graph.marked(title, caseID);
    } else return false; // cannot mark undone or marked vertex
  }

  function unmark(bytes32 title, uint caseID) public returns (bool) {
    if (!graph.marked(title, caseID)) return false; // cannot unmarked a non-marked vertex
    graph.unmark(title, caseID);
    return graph.done(title, caseID);
  }

  function getStatus(bytes32 title, uint caseID) public view returns (Graph.Status status) {
    return graph.getStatus(title, caseID);
  }





// TEST SETUPS:
  function smallTestSetup() public {
    graph.addVertex("a");
    graph.addVertex("ba");
    graph.addVertex("bb");
    graph.addVertex("c");
    graph.addVertex("d");

    graph.addEdge("root", "a");
    graph.addEdge("a", "ba");
    graph.addEdge("a", "bb");
    graph.addEdge("ba", "c");
    graph.addEdge("bb", "c");
    graph.addEdge("c", "d");

    uint caseID = 0;
    graph.addCase(caseID);

    graph.setStatus("a", caseID, Graph.Status.DONE);
  }

  function testSetup() public {
    ProcessFactory.metering(graph);
    ProcessFactory.beregningsgrundlag(graph);

    uint caseID = 0;
    graph.addCase(caseID);

    graph.setStatus("Arbejdstider", caseID, Graph.Status.DONE);
    graph.setStatus("Familieforhold", caseID, Graph.Status.DONE);
    graph.setStatus("Arbejdsfleksibilitet", caseID, Graph.Status.DONE);
    graph.setStatus("Bevilligede timer", caseID, Graph.Status.DONE);
    graph.setStatus("Sparede udgifter", caseID, Graph.Status.DONE);
    graph.setStatus("Udmåling afgørelse", caseID, Graph.Status.DONE);
  }


}

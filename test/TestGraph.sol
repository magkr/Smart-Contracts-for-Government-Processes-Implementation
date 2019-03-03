pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import { Graph } from "../contracts/Graph.sol";

contract TestGraph {
  Graph.Digraph private _graph;

  function testInit() public {
    //Arrange
    uint8 V = 0;

    //Act
    Graph.init(_graph);

    //Assert
    Assert.equal(_graph.V, V, "V should be 0 after init");
  }




}

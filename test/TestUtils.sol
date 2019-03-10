pragma solidity ^0.5.0;

import "truffle/Assert.sol";

contract TestUtils {

  mapping(bytes32 => uint) idxs;
  function testRegularMappingFunctionality() public {
    idxs["hej"] = 1;
    Assert.equal(idxs["hej"], 1, "title hej has idx 0");
    Assert.equal(idxs["fail"], 0, "title fail does not exist");
  }

  struct Vertex {
  	bytes32 title;
    uint[] adj;
    uint[] req;
  }
  function testDeleteOnList() public {
    Vertex[] memory vs = new Vertex[](3);
    vs[0] = Vertex("test", new uint[](0), new uint[](0));
    vs[1] = Vertex("hej", new uint[](0), new uint[](0));

    Assert.equal(vs[0].title, "test", "title of vs[0] should be 0");

    delete vs[0];

    Assert.equal(vs[0].title, 0, "title of vs[0] should be deleted (set to 0)");
    Assert.equal(vs[1].title, "hej", "title of vs[1] title should be hej");
    Assert.equal(vs[2].title, 0, "title of non-existing vertex should be 0");
  }

}

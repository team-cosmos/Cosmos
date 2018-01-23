pragma solidity ^0.4.19;

import "node.sol";

contract Vertex is Node {

	string public name;

	function setName(string newName) public returns (bool) {
    	name = newName;
    	return true;
    }
}
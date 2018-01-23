pragma solidity ^0.4.19;

contract Node {

    bytes32 public id;
    bytes32 public prev;
    bytes32 public next;

    function Node() public {
        id = keccak256(now);
        prev = -1;
        next = -1;
    }

    function setId(bytes32 newId) public returns (bool) {
    	id = newId;
    	return true;
    }

    function setPrev(bytes32 newPrev) public returns (bool) {
    	prev = newPrev;
    	return true;
    }

    function setNext(bytes32 newNext) public returns (bool) {
    	next = newNext;
    	return true;
    }

}
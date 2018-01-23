pragma solidity ^0.4.19;

import "node.sol";

contract LinkedList {

    uint public length;
    bytes32 private head;
    bytes32 private tail;
    mapping (bytes32 => Node) private nodes;

    // event Append(bytes32 id, bytes32 prev, bytes32 next); 
    // event Remove(bytes32 id, bytes32 prev, bytes32 next);

    function LinkedList() public {
        length = 0;
        head = -1;
        tail = head;
    }

    function append(Node newNode) public returns (bool) {

        if (length == 0) { 
            // Assign new head.
            head = newNode.id();  
        } else { 
            // Point previous block to new id.
            bool tailSet = nodes[tail].setNext(newNode.id());
            if (!tailSet) {
                return false; 
            }
        }

        // Attach to end of chain.
        nodes[newNode.id()] = newNode;
        tail = newNode.id();

        // Do some book keeping.
        length += 1;
        // Append(node.id, node.prev, node.next);

        return true;
    }   

    function remove(uint index) public returns (bool) {
        // Sanitize input.
        if (index >= length) {
            return false;
        }

        // Fetch node at index.
        Node currNode = nodes[head];
        for (uint i = 0; i < index; i++) {
            currNode = nodes[currNode.next()];
        }

        // Rearrange arrows.
        bool prevSet = nodes[currNode.prev()].setNext(currNode.next());
        bool nextSet = nodes[currNode.next()].setPrev(currNode.prev());
        if (!prevSet || !nextSet) {
            return false; 
        }

        // Delete from memory.
        delete nodes[currNode.id()];
        length -= 1;

        // Remove(currNode.id, currNode.prev,currNode.next);
        return true;
    }

    function get(uint index) public returns (Node, bool) {
        // Sanitize input.
        if (index >= length) {
            return (nullNode(), false);
        }

        // Fetch node at index.
        Node currNode = nodes[head];
        for (uint i = 0; i < index; i++) {
            currNode = nodes[currNode.next()];
        }

        return (currNode, true);
    }

    function nullNode() private returns (Node) {
        Node n = new Node();
        n.setId(-1);
        n.setPrev(-1);
        n.setNext(-1);
        return n;
    }

}

pragma solidity ^0.4.19;

import "linkedlist.sol";
import "vertex.sol";

contract Graph {

	/* List of Vertex elements. */
	LinkedList[] adjacencyList; 

	mapping (bytes32 => Vertex) private vertices;
	mapping (bytes32 => uint) private vertexIndices;

	/* Vertex functions */
	function addVertex(string name) public returns (bool) {
		if (hasVertexByName(name)) {
			return false;
		}

		// Create vertex with name.
		Vertex v = new Vertex();
		v.setName(name);

		// Create a new linked list and append new vertex.
		LinkedList l = new LinkedList();
		l.append(v);

		// Add new linked list to adjacencyList.
		adjacencyList.push(l);
		vertexIndices[v.id()] = adjacencyList.length - 1;
		return true;
	}

	function removeVertex(Vertex v) public returns (bool) {

		if (!hasVertex(v)) {
			return false;
		}

		// In every linked list, references to v.
		for (uint i = 0; i < adjacencyList.length; i++) {
			// Skip linked list of deleting vertex.
			if (i != vertexIndices[v.id()]) {
				LinkedList l = adjacencyList[i];
				if (removeVertexFromLinkedList(l, v)) {
					return true;
				}
			}
        } 

        // Delete from storage.
       	delete adjacencyList[vertexIndices[v.id()]];
       	delete vertexIndices[v.id()];
       	delete vertices[v.id()];

        return false;
	}

	function hasVertex(Vertex v) public returns (bool) {
		bytes32 id = v.id();
		Vertex stored = vertices[id];
		if (isEqualVertex(stored, v)) {
			return false;
		} 
        return true;
	}

	function hasVertexByName(string name) public returns (bool) {
		for (uint i = 0; i < adjacencyList.length; i++) {
			LinkedList l = adjacencyList[i];

			Vertex v; bool found;
			(v, found) = getVertex(l,i);

			if (found && v.name() == name) {
				return true;
			}
        }
        return false;
	}

	function getVertexByName(string name) public returns (Vertex, bool) {
		for (uint i = 0; i < adjacencyList.length; i++) {
			LinkedList l = adjacencyList[i];
			

			Vertex v; bool found;
			(v, found) = getVertex(l,i);

			if (found && v.name() == name) {
				return (v, true);
			}
        }

        // Query failed.
        return (nullVertex(), false);
	}

	/* Directed edge functions */
	function addDirectedEdge(Vertex from, Vertex to) public returns (bool) {
		if (!hasVertex(from)) {
			return false;
		} else if (!hasVertex(to)) {
			return false;
		} else if (hasDirectedEdge(from, to)) {
        	return false;
        } else {
        	uint fromIndex = vertexIndices[from.id()];
        	LinkedList l = adjacencyList[fromIndex];
        	l.append(to); 
        }
	}

	function removeDirectedEdge(Vertex from, Vertex to) public returns (bool) {
		if (!hasVertex(from)) {
			return false;

		} else if (!hasVertex(to)) {
			return false;

		} else {
        	uint index = vertexIndices[from.id()];
			LinkedList l = adjacencyList[i];

			// Iterate through linked list and remove vertex 'to'.
			for (uint i = 1; i < l.length(); i++) {

				Vertex v; bool found;
				(v, found) = getVertex(l,i);

				if (found && isEqualVertex(v, to)) {
					l.remove(i); 
					return true;
				}
			}
			return false;
        	
        }
	}

	function hasDirectedEdge(Vertex from, Vertex to) public returns (bool) {
		if (!hasVertex(from)) {
			return false;
		} else if (!hasVertex(to)) {
			return false;
		}

		uint index = vertexIndices[from.id()];
		LinkedList l = adjacencyList[i];

		for (uint i = 1; i < l.length(); i++) {

			Vertex v; bool found;
			(v, found) = getVertex(l,i);

			if (found && isEqualVertex(v, to)) {
				return true;
			}
		}

		return false;
	}

	/* Private helpers */

	/* Remove a vertex from a linked list. */
	function removeVertexFromLinkedList(LinkedList list, Vertex v) private returns (bool) { 

		for (uint i = 0; i < list.length(); i++) {

			Vertex stored; bool found;
			(stored, found) = getVertex(list,i);

			if (found && isEqualVertex(stored, v)) {
				list.remove(i);
				return true;
			}
        } 
        return false;
	}

	function isEqualVertex(Vertex a, Vertex b) private returns (bool) {
		if (a.id() != b.id()) {
			return false;
		} else if (a.name() != b.name()) {
			return false;
		} 

		return true;
	}


	function getVertex(LinkedList l, uint i) private returns (Vertex, bool) {
		Node n; bool found;
		(n, found) = l.get(i);

		if (found) {
			return (Vertex(address(n)), true); // Type conversion from Node to Vertex.
		} else {
			return (nullVertex(), false);
		}
	}

	function nullVertex() private returns (Vertex) {
		Vertex n = new Vertex();
        n.setId(-1);
        n.setPrev(-1);
        n.setNext(-1);
        n.setName("");
        return n;
	}
}
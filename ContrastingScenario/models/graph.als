sig Node {
	adj : set Node
}

/*The graph is undirected, ie, edges are symmetric.*/
pred undirectedO {
	adj = ~adj
}

/*The graph is oriented, ie, contains no symmetric edges.*/
pred orientedO {
	no adj & ~adj
}

/*The graph is acyclic, ie, contains no directed cycles.*/
pred acyclicO {
	all n : Node | n not in n.^adj
}

/*The graph is complete, ie, every node is connected to every other node.*/
pred completeO {
	adj = Node -> Node
}

/*The graph contains no loops, ie, nodes have no transitions to themselves.*/
pred noLoopsO {
	no adj & iden
}

/*The graph is weakly connected, ie, it is possible to reach every node from every node ignoring edge direction.*/
pred weaklyConnectedO {
	all n:Node | Node = n.*(adj+~adj)
}

/*The graph is strongly connected, ie, it is possible to reach every node from every node considering edge direction.*/
pred stonglyConnectedO {
	all n:Node | Node = n.*adj
}

/*The graph is transitive, ie, if two nodes are connected through a third node, they also are connected directly.*/
pred transitiveO {
	adj = ^adj
}
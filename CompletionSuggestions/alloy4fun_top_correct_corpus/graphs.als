sig Node {
	adj : set Node
}

/*The graph is undirected, ie, edges are symmetric.*/
pred undirected { //same as oracle
	adj = ~adj
}

/*The graph is oriented, ie, contains no symmetric edges.*/
pred oriented { //same as oracle
	no adj & ~adj
}

/*The graph is acyclic, ie, contains no directed cycles.*/
pred acyclic { //same as oracle
	all n : Node | n not in n.^adj
}

/*The graph is complete, ie, every node is connected to every other node.*/
pred complete {
	all n:Node |Node in n.adj
}

/*The graph contains no loops, ie, nodes have no transitions to themselves.*/
pred noLoops {
	all n:Node | n not in n.adj
}

/*The graph is weakly connected, ie, it is possible to reach every node from every node ignoring edge direction.*/
pred weaklyConnected { //same as oracle
	all n:Node | Node = n.*(adj+~adj)
}

/*The graph is strongly connected, ie, it is possible to reach every node from every node considering edge direction.*/
pred stonglyConnected { //same as oracle
	all n:Node | Node = n.*adj
}

/*The graph is transitive, ie, if two nodes are connected through a third node, they also are connected directly.*/
pred transitive { //same as oracle
	adj = ^adj
}

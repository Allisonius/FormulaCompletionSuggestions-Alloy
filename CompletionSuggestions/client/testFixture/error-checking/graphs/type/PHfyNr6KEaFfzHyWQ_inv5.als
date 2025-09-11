sig Node {
	adj : set Node
}
pred inv5{
all a: Node.adj | a not in ^adj
}




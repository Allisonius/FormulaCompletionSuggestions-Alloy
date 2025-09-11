sig Node {
	adj : set Node
}
pred inv1{
all n : Node, a : n.adj | a->n in Node.adj
}




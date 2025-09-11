sig Node {
	adj : set Node
}
pred inv1{
all n : Node, a : n.adj | n->a => a->n
}




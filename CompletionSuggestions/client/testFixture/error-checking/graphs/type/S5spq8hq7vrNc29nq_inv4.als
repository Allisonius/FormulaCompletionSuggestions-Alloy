sig Node {
	adj : set Node
}
pred inv4{
all n1, n2: Node | n1->n2 implies n2->n1 in adj
}




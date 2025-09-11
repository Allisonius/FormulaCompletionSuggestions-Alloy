sig Node {
	adj : set Node
}
pred inv6{
all n1, n2, n3: Node | n1->n2 and n3->n2 implies n1->n3 in adj
}




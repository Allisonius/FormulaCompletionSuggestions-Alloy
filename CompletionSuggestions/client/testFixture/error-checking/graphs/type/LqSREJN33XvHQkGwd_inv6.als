sig Node {
	adj : set Node
}
pred inv6{
all n1, n2, n3:  Node | n1->n2 in adj and n2->n3 implies n1.*n3 in adj
}




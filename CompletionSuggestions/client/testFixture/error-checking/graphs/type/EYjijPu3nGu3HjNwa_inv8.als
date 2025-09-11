sig Node {
	adj : set Node
}
pred inv8{
all n1, n2, n3 : Node | ((n1->n2 in adj) & (n2->n3 in adj)) implies (n1->n3 in adj)
}





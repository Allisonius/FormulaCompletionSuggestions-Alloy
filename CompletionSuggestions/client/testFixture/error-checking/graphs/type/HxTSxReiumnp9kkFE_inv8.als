sig Node {
	adj : set Node
}
pred inv8{
all n1, n2, n3 : Node | ((n1->n2) and (n2->n3)) implies (n1->n3)
}





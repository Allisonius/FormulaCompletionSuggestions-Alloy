sig Node {
	adj : set Node
}
pred inv8{
all n1, n2, n3 : Node | (some(n1->n2) and some(n2->n3)) implies (n1->n3)
}





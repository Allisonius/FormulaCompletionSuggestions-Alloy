sig Node {
	adj : set Node
}
pred inv5{
all n1, n2: Node | no n1->n2->n1 in Node
}




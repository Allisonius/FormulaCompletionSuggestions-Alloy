sig Node {
	adj : set Node
}
pred inv5{
all n: Node | no n->n in adj
}




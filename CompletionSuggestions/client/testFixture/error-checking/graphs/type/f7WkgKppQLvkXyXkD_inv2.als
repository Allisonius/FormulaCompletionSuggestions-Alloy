sig Node {
	adj : set Node
}
pred inv2{
all n1,n2:Node | n1->n2 in adj implies no n2->n1 in adj
}




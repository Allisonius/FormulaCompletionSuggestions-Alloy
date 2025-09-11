sig Node {
	adj : set Node
}
pred inv3{
inv2
all n : Node | n not in n.adj*
}

pred inv2{
all n1, n2 : Node | n1->n2 in adj implies not n2->n1 in adj
}




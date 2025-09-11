sig Node {
	adj : set Node
}
pred inv8{
all disj n1,n2,n3: Node | (n1->n2 and n3->n2) in adj implies n1->n3 in adj
}





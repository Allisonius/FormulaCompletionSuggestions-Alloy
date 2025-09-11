sig Node {
	adj : set Node
}
pred inv1{
all disj n1, n2 : n1 in n2.adj implies n2 in n1.adj
}




sig Node {
	adj : set Node
}
pred inv2{
all n:Node | n.adj not adj.n
}




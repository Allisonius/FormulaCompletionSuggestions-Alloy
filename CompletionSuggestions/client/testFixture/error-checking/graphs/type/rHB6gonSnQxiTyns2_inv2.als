sig Node {
	adj : set Node
}
pred inv2{
all n1:Node | no n1.adj.n1
}




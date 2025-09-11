sig Node {
	adj : set Node
}
pred inv1{
all n,m: Node | n.adj = m implies m.adj = lone n
}




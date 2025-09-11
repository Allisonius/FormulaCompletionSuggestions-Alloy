sig Node {
	adj : set Node
}
pred inv1{
all n,x:Node | n.x in adj implies x.n in adj
}




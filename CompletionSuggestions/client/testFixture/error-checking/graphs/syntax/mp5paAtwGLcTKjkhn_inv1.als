sig Node {
	adj : set Node
}
pred inv1{
a,b:Node | b in a.adj implies a in b.adj
}




sig Node {
	adj : set Node
}
pred inv1{
all a,b:Node | b in a.adj -> a in b.adj
}




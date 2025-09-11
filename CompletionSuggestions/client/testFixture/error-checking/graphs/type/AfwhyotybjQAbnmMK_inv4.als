sig Node {
	adj : set Node
}
pred inv4{
all n : Node | adj not in n.adj
}




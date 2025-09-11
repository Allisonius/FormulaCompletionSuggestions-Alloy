sig Node {
	adj : set Node
}
pred inv1{
all adj1, adj2 : Node | x->adj1 and x->adj2 implies adj1 = adj2
}




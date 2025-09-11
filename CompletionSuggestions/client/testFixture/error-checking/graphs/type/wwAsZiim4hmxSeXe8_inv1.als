sig Node {
	adj : set Node
}
pred inv1{
all n : Node | some n in n.adj.~adj
}




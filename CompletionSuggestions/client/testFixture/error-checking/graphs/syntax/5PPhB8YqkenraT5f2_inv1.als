sig Node {
	adj : set Node
}
pred inv1{
all n: Node | all a: n.adj | n in a.adj
}




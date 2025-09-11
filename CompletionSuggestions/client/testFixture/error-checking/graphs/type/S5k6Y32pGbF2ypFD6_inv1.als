sig Node {
	adj : set Node
}
pred inv1{
all n: Node | n.adj in Node implies some n.adj.adj = n
}




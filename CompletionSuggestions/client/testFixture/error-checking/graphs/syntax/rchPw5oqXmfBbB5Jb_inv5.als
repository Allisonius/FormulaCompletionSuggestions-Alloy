sig Node {
	adj : set Node
}
pred inv5{
all n: Nodes | n not in n.adj
}




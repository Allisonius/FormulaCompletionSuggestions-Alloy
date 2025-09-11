sig Node {
	adj : set Node
}
pred inv6{
all n1:Node | some ((^adj.n1:>Node) + (n1.^adj:>Node)) = Node
}




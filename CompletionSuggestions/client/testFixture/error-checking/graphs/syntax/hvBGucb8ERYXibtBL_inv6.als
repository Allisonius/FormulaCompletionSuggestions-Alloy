sig Node {
	adj : set Node
}
pred inv6{
all n1:Node | ((^adj.n1:>Node) + (n1.^adj:>Node) + (n1.^adk:>n1)) = Node
}




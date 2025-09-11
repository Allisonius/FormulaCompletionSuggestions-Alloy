sig Node {
	adj : set Node
}
pred inv6{
all n: Node | n.adj in adj or n.~adj in adj
}




sig Node {
	adj : set Node
}
pred inv6{
all x: Node | x in x.^(adj) or adj.x
}




sig Node {
	adj : set Node
}
pred inv4{
all x, y: Node | x in (y.adj or y.^(adj)) and y in (x.adj or x.^(adj))
}




sig Node {
	adj : set Node
}
pred inv6{
all x, y : Node | x in ^adj.y & y in ^adj.x
}




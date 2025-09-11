sig Node {
	adj : set Node
}
pred inv6{
all x, y : Node | (x<:^adj).y
}




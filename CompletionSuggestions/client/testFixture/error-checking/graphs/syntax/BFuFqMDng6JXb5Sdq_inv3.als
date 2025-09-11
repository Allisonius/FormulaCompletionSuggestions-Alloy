sig Node {
	adj : set Node
}
pred inv3{
all x, y z : Node | x->y in adj and z->y in adj implies y = z
}




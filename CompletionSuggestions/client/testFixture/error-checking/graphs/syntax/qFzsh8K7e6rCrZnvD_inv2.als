sig Node {
	adj : set Node
}
pred inv2{
all x, y : Node | x->y in adj and y->x in adj implies y == x

}




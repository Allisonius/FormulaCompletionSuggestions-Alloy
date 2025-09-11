sig Node {
	adj : set Node
}
pred inv6{
all x, y : Node | x->y in adj implies y->x not in adj and ode in x.^adj + x + ^adj.x

}




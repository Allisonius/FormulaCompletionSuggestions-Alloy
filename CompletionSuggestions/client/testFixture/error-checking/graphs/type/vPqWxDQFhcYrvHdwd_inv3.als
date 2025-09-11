sig Node {
	adj : set Node
}
pred inv3{
all x, y : Node | x->y in adj implies y->x not in adj and no ^(x.adj) & x
}




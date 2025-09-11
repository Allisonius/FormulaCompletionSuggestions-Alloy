sig Node {
	adj : set Node
}
pred inv1{
all x,y : Node | x->y in Node and y->x in Node
}




sig Node {
	adj : set Node
}
pred inv5{
all x, y : Node | x->y in adj implies no y->x in adj

}




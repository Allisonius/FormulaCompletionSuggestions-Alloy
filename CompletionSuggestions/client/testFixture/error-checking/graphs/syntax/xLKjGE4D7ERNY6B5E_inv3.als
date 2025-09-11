sig Node {
	adj : set Node
}
pred inv3{
all a,b,c:Node | a->b in adj b->c in adj
}




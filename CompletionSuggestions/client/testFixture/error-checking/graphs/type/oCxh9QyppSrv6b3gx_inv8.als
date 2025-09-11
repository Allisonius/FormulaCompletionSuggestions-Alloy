sig Node {
	adj : set Node
}
pred inv8{
all a,b,c:Node | a->b->c in adj implies a->c in adj
}





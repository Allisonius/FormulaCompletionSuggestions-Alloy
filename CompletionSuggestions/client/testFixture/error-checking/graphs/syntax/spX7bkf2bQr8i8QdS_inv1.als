sig Node {
	adj : set Node
}
pred inv1{
all Node a,b | a->b in adj implies b->a in adj
}




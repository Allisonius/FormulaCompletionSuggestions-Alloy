sig Node {
	adj : set Node
}
pred inv6{
all a,b:Node | a.^b in adj implies b->a in adj
}




sig Node {
	adj : set Node
}
pred inv4{
all a:Node | a in a.adj implies a in ~a.adj
}




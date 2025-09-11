sig Node {
	adj : set Node
}
pred inv1{
all a:Node.adj | ~a in adj
}




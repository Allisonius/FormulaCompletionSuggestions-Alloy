sig Node {
	adj : set Node
}
pred inv1{
all n : adj | ~n in Node.adj
}




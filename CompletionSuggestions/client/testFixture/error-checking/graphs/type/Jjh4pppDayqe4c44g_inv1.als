sig Node {
	adj : set Node
}
pred inv1{
all n : Node.adj | ~n in Node.adj
}




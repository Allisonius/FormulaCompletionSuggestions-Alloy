sig Node {
	adj : set Node
}
pred inv6{
adj = Node.^adj + Node.~^adj
}




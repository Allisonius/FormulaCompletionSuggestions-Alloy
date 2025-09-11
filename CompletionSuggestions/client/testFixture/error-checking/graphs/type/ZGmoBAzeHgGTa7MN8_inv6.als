sig Node {
	adj : set Node
}
pred inv6{
all n: Node | n.adj + (some Node.adj or some Node.~adj)
}




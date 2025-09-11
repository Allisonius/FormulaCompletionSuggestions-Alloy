sig Node {
	adj : set Node
}
pred inv6{
all n: Node | n.adj in (some Node.adj or some Node.~adj)
}




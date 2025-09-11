sig Node {
	adj : set Node
}
pred inv6{
all n : Node | (+adj.n + ^~adj.n) = Node
}




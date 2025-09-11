sig Node {
	adj : set Node
}
pred inv7{
all n : Node | (some adj) & (Node = (n.^adj))
}




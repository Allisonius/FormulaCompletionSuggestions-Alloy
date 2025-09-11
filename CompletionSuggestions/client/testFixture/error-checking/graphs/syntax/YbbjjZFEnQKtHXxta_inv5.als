sig Node {
	adj : set Node
}
pred inv5{
all n : Node | n not in n.adj*
}




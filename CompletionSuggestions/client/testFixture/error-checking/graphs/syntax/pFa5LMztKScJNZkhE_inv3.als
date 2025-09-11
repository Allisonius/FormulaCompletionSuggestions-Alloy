sig Node {
	adj : set Node
}
pred inv3{
all n : Node | no (n.^node & n)
}




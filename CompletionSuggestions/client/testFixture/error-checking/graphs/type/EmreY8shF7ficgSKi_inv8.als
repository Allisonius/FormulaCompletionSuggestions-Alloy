sig Node {
	adj : set Node
}
pred inv8{
all n1, n2 : Node | (n2 in n1.Node.Node) implies (n2 in n1.Node)
}





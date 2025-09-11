sig Node {
	adj : set Node
}
pred inv1{
all n: Node | no n in n.^adj
}




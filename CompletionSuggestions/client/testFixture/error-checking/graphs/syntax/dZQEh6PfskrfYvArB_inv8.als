sig Node {
	adj : set Node
}
pred inv8{
all n1 : Node, some n2 : Node | n2 in n1.adj implies n1 in n2.adj
}





sig Node {
	adj : set Node
}
pred inv1{
all n1, some n2: Node | n1 in n2.adj iff n1.adj in n2
}




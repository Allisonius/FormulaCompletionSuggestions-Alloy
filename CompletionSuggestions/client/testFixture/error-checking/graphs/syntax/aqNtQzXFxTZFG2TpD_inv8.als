sig Node {
	adj : set Node
}
pred inv8{


all n1 : Node | some n2 in n1.adj.adj => n2 in n1.adj
}





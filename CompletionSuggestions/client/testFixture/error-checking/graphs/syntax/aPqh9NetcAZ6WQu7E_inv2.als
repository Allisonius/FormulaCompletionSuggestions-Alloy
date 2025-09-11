sig Node {
	adj : set Node
}
pred inv2{
all n, n1 : Node | n->n1 in adj => n1->n not in adj

adj & ~adj in id
}




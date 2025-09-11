sig Node {
	adj : set Node
}
pred inv1{
all n:Node, n2:Node | n2 in n.adj => false

}




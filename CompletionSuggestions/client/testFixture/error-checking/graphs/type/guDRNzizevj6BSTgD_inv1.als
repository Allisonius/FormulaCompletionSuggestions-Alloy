sig Node {
	adj : set Node
}
pred inv1{
all n1, n2 : Node | (n1.adj.n2) implies (n2.adj.n1)

}




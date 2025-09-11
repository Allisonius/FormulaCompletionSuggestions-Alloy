sig Node {
	adj : set Node
}
pred inv1{
all n1, n2 : Node | (n1.link.n2) implies (n2.link.n1)

}




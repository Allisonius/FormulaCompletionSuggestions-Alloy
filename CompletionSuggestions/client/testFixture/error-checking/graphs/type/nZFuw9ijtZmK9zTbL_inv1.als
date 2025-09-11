sig Node {
	adj : set Node
}
pred inv1{
all n : Node | one n.adj and n.(~adj)
}




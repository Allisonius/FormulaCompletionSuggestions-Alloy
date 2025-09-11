sig Node {
	adj : set Node
}
pred inv1{
all n1,n2:Node | adj(n1,n2) implies adj(n2,n1)
}




sig Node {
	adj : set Node
}
pred inv1{
all n1,n2 in Node | n1.adj = n2 iff n2.adj = n1
}




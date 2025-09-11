sig Node {
	adj : set Node
}
pred inv6{
all n1,n2:Node | n2 in ^(n1.adj + n1.~adj) || n1 in ^(n2.adj + n2.~adj)
}




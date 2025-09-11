sig Node {
	adj : set Node
}
pred inv4{
all disj n1,n2: Node | (n1 == n2) || (n1 in n2.^adj)
}




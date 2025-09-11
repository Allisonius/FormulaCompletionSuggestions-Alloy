sig Node {
	adj : set Node
}
pred inv4{
all n1,n2:Node | n2 in (univ - n1) | n1 in n2.^adj <=> n2 in n1.^adj
}




sig Node {
	adj : set Node
}
pred inv1{
all n1:Node | let n2:Node in n1.adj | n1 in n2.adj && n2 in n1.adj
}




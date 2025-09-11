sig Node {
	adj : set Node
}
pred inv8{
all n1, n2, n3: Node | #{n1,n2,n3} = 3 and n1 in n3.adj and n2 in n3.adj implies n1 -> n2 in adj
}





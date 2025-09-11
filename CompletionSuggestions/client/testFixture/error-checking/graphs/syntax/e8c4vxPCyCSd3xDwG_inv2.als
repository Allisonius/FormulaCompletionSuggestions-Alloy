sig Node {
	adj : set Node
}
pred inv2{
all n1,n2: Node | n1 in n2.adj implies n2 in n1.adj




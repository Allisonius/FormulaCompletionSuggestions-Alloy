sig Node {
	adj : set Node
}
pred inv1{
all n: Node{n.adj = ~(n.adj)}

}




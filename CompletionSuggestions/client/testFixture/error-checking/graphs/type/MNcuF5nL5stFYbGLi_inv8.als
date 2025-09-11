sig Node {
	adj : set Node
}
pred inv8{

all n : Node | n->(n.adj.adj.Node) in adj

}





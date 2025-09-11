sig Node {
	adj : set Node
}
pred inv8{

all n : Node | let n1 = n.adj.adj.Node | n->n1 in adj

}





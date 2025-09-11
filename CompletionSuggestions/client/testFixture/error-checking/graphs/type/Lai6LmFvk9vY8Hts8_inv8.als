sig Node {
	adj : set Node
}
pred inv8{

let n1 = n.adj.adj.Node | (all n : Node | n->n1 in adj)

}





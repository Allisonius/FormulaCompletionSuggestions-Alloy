sig Node {
	adj : set Node
}
pred inv2{

all n: Node | no n.adj.n
}




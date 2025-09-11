sig Node {
	adj : set Node
}
pred inv8{
n,nn,nnn : Node | nn in n.adj.adj implies nn in n.adj
}





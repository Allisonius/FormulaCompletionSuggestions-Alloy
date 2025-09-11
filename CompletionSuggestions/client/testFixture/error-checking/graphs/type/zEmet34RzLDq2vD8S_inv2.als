sig Node {
	adj : set Node
}
pred inv2{
all n:adj, x:adj | n in x.adj => x not in n.adj
}




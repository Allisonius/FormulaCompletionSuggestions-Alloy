sig Node {
	adj : set Node
}
pred inv2{
all n:adj |all x:n.adj => n not in x.adj
}




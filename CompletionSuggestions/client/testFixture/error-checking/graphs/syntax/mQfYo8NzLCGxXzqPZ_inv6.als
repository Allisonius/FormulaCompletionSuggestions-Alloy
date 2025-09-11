sig Node {
	adj : set Node
}
pred inv6{
fun conn(a : Node) : set Node {
a.adj + adj.a
}

all a, b : Node | b in a.*conn
}




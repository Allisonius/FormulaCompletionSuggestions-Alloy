sig Node {
	adj : set Node
}
pred inv6{
all a:Node, b:Node | b in ^(a.adj + a.~adj)
}




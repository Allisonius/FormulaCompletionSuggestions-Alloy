sig Node {
	adj : set Node
}
pred inv6{
all b:Node | b in ^(adj + ~adj)
}




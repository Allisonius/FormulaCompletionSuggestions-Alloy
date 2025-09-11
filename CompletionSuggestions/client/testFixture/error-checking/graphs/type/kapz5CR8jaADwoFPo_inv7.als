sig Node {
	adj : set Node
}
pred inv7{
inv4 & inv2
}

pred inv2{
no ~adj & adj
}

pred inv4{
adj = Node -> Node
}




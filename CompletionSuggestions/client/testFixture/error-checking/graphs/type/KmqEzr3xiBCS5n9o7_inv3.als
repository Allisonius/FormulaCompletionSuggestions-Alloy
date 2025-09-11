sig Node {
	adj : set Node
}
pred inv3{
all a:Node | no ^a.adj & ~(^a.adj)
}




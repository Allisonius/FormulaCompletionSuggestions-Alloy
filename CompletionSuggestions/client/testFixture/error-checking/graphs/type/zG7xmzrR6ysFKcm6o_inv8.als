sig Node {
	adj : set Node
}
pred inv8{
all a:Node , b:Node, c:Node | (a->b in adj & b->c in adj) implies a->c in adj
}





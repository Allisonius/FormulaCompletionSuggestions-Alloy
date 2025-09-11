sig Node {
	adj : set Node
}
pred inv7{
all v1, v2 : Node | v1->v2 in adj & v2->v1 in adj
}




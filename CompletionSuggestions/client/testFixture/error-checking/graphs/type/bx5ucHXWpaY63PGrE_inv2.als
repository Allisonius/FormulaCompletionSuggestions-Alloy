sig Node {
	adj : set Node
}
pred inv2{
all v1, v2 : Node | v1->v2 in adj implies no v2->v1 in adj
}




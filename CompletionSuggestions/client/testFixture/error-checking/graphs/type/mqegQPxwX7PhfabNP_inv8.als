sig Node {
	adj : set Node
}
pred inv8{
all v1,v2,v3:Node | v1->v2 in adj and v2->v3 in adj implies v1->v3
}





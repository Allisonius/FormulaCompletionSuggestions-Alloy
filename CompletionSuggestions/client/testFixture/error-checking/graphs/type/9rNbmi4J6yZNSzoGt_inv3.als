sig Node {
	adj : set Node
}
pred inv3{
all v1, v2, v3 : Node | v1->v2 in adj and v2->v3 implies not v1 = v3
}




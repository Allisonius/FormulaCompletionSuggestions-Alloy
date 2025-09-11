sig Node {
	adj : set Node
}
pred inv1{
all e1, e2 : Node | e1 -> e2 in Node implies e2 -> e1 in Node
}




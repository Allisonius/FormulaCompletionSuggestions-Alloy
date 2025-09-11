sig Node {
	adj : set Node
}
pred inv1{
all disj n : Node | n in adj.~adj
}




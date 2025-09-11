sig Node {
	adj : set Node
}
pred inv1{
all a:A Node | a -> b implies b -> a in adj
}




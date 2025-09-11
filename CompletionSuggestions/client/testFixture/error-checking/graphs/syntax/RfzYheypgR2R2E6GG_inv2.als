sig Node {
	adj : set Node
}
pred inv2{
all a: adj | -a not in ~adj
}




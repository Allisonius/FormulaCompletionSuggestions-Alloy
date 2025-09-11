sig Node {
	adj : set Node
}
pred inv7{
all a:Node | adj = a.^adj
}




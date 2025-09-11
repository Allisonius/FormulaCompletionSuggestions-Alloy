sig Node {
	adj : set Node
}
pred inv2{
all adj:Node | adj != ~adj
}




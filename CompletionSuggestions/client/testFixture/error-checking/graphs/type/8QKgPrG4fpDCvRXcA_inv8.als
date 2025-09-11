sig Node {
	adj : set Node
}
pred inv8{
all a:Node , b:Node | b in a.next*adj
}





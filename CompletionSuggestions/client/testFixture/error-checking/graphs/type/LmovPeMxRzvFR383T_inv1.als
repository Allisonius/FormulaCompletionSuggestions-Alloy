sig Node {
	adj : set Node
}
pred inv1{
all x, y: Node | y in x.Node implies x in y.Node
}




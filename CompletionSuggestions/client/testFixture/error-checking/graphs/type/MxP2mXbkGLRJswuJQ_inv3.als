sig Node {
	adj : set Node
}
pred inv3{

all a:Node | a not int a.^adj
}




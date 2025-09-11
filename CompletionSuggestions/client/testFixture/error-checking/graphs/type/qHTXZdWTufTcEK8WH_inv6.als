sig Node {
	adj : set Node
}
pred inv6{
all a, b : Node | b in (a.*adj + adj.*a)
}




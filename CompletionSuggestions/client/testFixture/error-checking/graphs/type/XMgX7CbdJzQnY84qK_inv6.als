sig Node {
	adj : set Node
}
pred inv6{
Node in (Node.*adj  + adj.*Node)
}




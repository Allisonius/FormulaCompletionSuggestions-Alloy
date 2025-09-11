sig Node {
	adj : set Node
}
pred inv6{
all e1 | Node in (e1.*adj + *adj.e1)
}




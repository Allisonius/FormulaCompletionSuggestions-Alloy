sig Node {
	adj : set Node
}
pred inv8{
all n,o,p:Node | n->o and o->p in adj implies n->p in adj
}





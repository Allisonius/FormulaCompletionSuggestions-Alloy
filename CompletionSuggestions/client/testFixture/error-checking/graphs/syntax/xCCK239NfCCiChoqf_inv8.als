sig Node {
	adj : set Node
}
pred inv8{
all disj a,b,c : Node | (a in ajd.b and c in b.adj) => c in a.adj
}





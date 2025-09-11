sig Node {
	adj : set Node
}
pred inv1{
all disj n, m: Node | n.adj in m if m.adj in n
}




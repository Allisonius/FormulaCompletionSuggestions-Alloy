sig Node {
	adj : set Node
}
pred inv6 {
all disj n1, n2 : Node | n2 in n1.^(inv1Enclosure)
}

pred inv1{
all disj n1,n2 : Node | n2 in n1.adj => n2 in adj.n1
}

pred inv6c {
	all n:Node | Node = n.*(adj+~adj)
}

check correct { inv6 <=> inv6c}
pred under { inv6 and !inv6c}
pred over { !inv6 and inv6c}
run over 
run under 




sig Node {
	adj : set Node
}
pred inv1{
all n1, n2 : Node | (n1.n2) in adj  implies (n2.n1) in adj

}




sig Node {
	adj : set Node
}
pred inv3{

all n: None | n not in n.^adj

}




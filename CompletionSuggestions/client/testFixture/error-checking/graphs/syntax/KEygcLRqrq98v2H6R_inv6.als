sig Node {
	adj : set Node
}
pred inv6{

all n:Node | some n2:Node | n1 in (n2.^adj + ~(~adj).x)

}




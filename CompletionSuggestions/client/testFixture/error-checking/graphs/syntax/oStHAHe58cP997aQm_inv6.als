sig Node {
	adj : set Node
}
pred inv6{

all n:Node | some n2:Node | n in (n2.^adj + ~(~adj).x)

}




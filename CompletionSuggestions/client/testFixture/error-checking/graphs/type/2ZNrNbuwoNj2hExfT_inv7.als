sig Node {
	adj : set Node
}
pred inv7{
all n : Node | some Node<:adj & n
}




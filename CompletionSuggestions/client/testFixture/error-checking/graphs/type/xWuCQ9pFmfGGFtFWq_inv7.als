sig Node {
	adj : set Node
}
pred inv7{
all n : Node | some n<:adj & n
}




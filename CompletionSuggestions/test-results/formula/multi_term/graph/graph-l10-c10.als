sig Node {
	adj : set Node
}

pred undirectedO {
	adj = ~adj
}

pred orientedO {
	no adj & 
}

pred acyclicO {
	all n : Node | n not in n.^adj
}

pred completeO {
	adj = Node -> Node
}

pred noLoopsO {
	no adj & iden
}

pred weaklyConnectedO {
	all n:Node | Node = n.*(adj + ~adj)
}

pred stonglyConnectedO {
	all n:Node | Node = n.*adj
}

pred transitiveO {
	adj = ^adj
}
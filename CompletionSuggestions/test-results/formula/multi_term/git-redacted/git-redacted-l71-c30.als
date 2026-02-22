sig State {}

sig Name {
	refs : Commit -> State,
	heads : set State,
	HEAD : set State
}

abstract sig Node {
	belongsTo : Object lone -> Commit,
	name : one Name,
	parent : lone Dir,
	current : set State,
	samepath : set Node
}

sig File extends Node {
	content : one Blob,
	index : set State
}

sig Dir extends Node {
	tbc : Tree -> State
}

one sig Root extends Dir {}

abstract sig Object {
	stored : set State
}

sig Blob extends Object {
	merging : Blob -> lone Blob,
	conflict : set Blob
}

sig Tree extends Object {
	content : Name -> lone (Blob+Tree)
}

sig Commit extends Object {
	previous : set Commit,
	tree : one Tree
}

fun pointsTo[n : Name, s : State] : Commit {
	n.refs.s
}

pred isRootedAtCommit[n : Node, o : Object, c : Commit] {
	n in Root and o = c.tree
}

pred isStoredInIntermediateTree_part2[n : Node, o : Object] {
	some p : Tree | o = p.content[n.name]
}

pred isStoredInIntermediateTree_part3[n : Node, c : Commit] {
	some p : Tree | p -> c in n.parent.belongsTo
}

pred TreeFacts_1 {
	all n : Node - Root | one n.parent
}

pred TreeFacts_3 {
	all n : Node | n not in n.^parent
}

fun leaves [s : State, n : Node] : set File {
	(*parent).n & File & current.
}
sig State {}

sig Name {
	heads : set State,
	HEAD : set State,
	refs : Commit -> State
}

abstract sig Node {
	name : one Name,
	parent : lone Dir,
	current : set State,		// set of nodes currently in file system
	samepath : set Node, 		// auxiliary relation
	// n -> o -> c in belongsTo iff  o is an object in c.tree that corresponds to n
	belongsTo : Object lone -> Commit
}

sig File extends Node {
	content : one Blob,
	index : set State		// in staging area or not
}

sig Dir extends Node {
	tbc : Tree -> State // auxiliary relation
}

one sig Root extends Dir {}

abstract sig Object {
	stored : set State
}

sig Blob extends Object {
	conflict : set Blob,
	merging : Blob -> lone Blob
}

sig Tree extends Object {
	content : Name -> lone (Blob+Tree)
}

sig Commit extends Object {
	previous : set Commit,
	tree : one Tree
}
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
	current : set State,		// set of nodes currently in file system
	samepath : set Node 		// auxiliary relation
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
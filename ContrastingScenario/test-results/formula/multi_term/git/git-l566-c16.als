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

fun pointsTo[n : Name, s : State] : Commit {
	n.refs.s
}

fun HEAD[s : State] : Commit {
	pointsTo[HEAD.s, s]
}

pred isRootedAtCommit[n : Node, o : Object, c : Commit] {
	n in Root and o = c.tree
}

fun children : Tree -> Object {
	{t : Tree, o : Object | some n : Name | t->n->o in content}
}

pred isStoredInIntermediateTree_part1[n : Node, c : Commit] {
	some p : Tree | p in c.tree.^children + c.tree
}

pred isStoredInIntermediateTree_part2[n : Node, o : Object] {
	some p : Tree | o = p.content[n.name]
}

pred isStoredInIntermediateTree_part3[n : Node, c : Commit] {
	some p : Tree | p -> c in n.parent.belongsTo
}

pred isStoredInIntermediateTree[n : Node, o : Object, c : Commit] {
	isStoredInIntermediateTree_part1[n, c]
	isStoredInIntermediateTree_part2[n, o]
	isStoredInIntermediateTree_part3[n, c]
}

// true iff fsys node 'n' is commited as git object 'o' in commit 'c'
pred committedAs[n : Node, o : Object, c : Commit] {
	// either n is rooted at c or
	isRootedAtCommit[n, o, c] or isStoredInIntermediateTree[n, o, c]
}

pred TreeFacts_1 {
	all n : Node - Root | one n.parent
}

pred TreeFacts_2 {
	no Root.parent
}

pred TreeFacts_3 {
	all n : Node | n not in n.^parent
}

fact TreeFacts {
	TreeFacts_1
	TreeFacts_2
	TreeFacts_3
}

check {
	all s : State, f : File, ff : f.samepath & File | invariant[s] implies f.content = ff.content
} for 7 but 1 State

check {
	all s : State, n : current.s | invariant[s] implies no (current.s & (n.samepath-n))
} for 7 but 1 State

pred BlobFacts_1 {
	all b1, b2 : Blob | b1 -> b2 in conflict implies b2 -> b1 in conflict
}

pred BlobFacts_2 {
	// conflicting blobs can't be merged
	all b1, b2 : Blob | b1 -> b2 in conflict implies no b1.merging[b2]
}

pred BlobCanonicalization {
	no disj b1, b2 : Blob | b1.conflict = b2.conflict and b1.merging = b2.merging
}

pred TreeCanonicalization {
	no disj t1, t2 : Tree | t1.content = t2.content
}

fact Canonicalization {
	BlobCanonicalization
	TreeCanonicalization
}

pred AcyclicCommits {
	// Acyclic commits
	no c : Commit | c in c.^previous
}

pred AcyclicTrees {
	// Acyclic trees
	no t : Tree | t in t.^children
}

fact Acyclic {
	AcyclicCommits
	AcyclicTrees
}

pred allNodesHaveParents[s : State] {
	all n : current.s | n.parent in current.s
}

pred rootIsInCurrentState[s : State] {
	Root in current.s
}

pred noDuplicateNamesInDirectories[s : State] {
	all d : current.s, disj x,y : (parent.d) & current.s | x.name != y.name
}

pred currentFileSystemInvariant[s : State] {
	allNodesHaveParents[s]
	rootIsInCurrentState[s]
	noDuplicateNamesInDirectories[s]
}

pred allTreesStored[s : State] {
	all t : stored.s & Tree | Name.(t.content) in stored.s
}

pred allCommitsStored[s : State] {
	all c : stored.s & Commit | c.previous in stored.s and c.tree in stored.s
}

pred allRefsStored[s : State] {
	Name.refs.s in stored.s
}

pred storedObjectsInvariant[s : State] {
	allTreesStored[s]
	allCommitsStored[s]
	allRefsStored[s]
}

pred indexBlobsInvariant[s : State] {
	(index.s).content in stored.s
}

pred exactlyOneHEAD[s : State] {
	one HEAD.s
}

pred allFilesHaveUniquePaths[s : State] {
	all f : index.s | one f.samepath & index.s
}

pred noDuplicateParentPaths[s : State] {
	all f : index.s | no (f.^parent.samepath & index.s)
}

pred indexPathsInvariant[s : State] {
	allFilesHaveUniquePaths[s]
	noDuplicateParentPaths[s]
}

pred HEADInHeads[s : State] {
	HEAD.s in heads.s
}

pred headsInRefs[s : State] {
	heads.s in refs.s.Commit
}

pred headReferenceInvariant[s : State] {
	HEADInHeads[s]
	headsInRefs[s]
}

pred namePointsToInvariant[s : State] {
	all n : Name, s : State | lone pointsTo[n, s]
}

pred invariant[s : State] {
	// Current file system
	currentFileSystemInvariant[s]
	// Stored objects
	storedObjectsInvariant[s]
	// Index blobs must be in the object database
	indexBlobsInvariant[s]
	// Exactly one HEAD
	exactlyOneHEAD[s]
	// Index must not contain duplicate paths
	indexPathsInvariant[s]
	// HEAD doesn't necessarily need to be referenced
	headReferenceInvariant[s]
	// Each name can only point to at most one commit object
	namePointsToInvariant[s]
}

pred tbcInvariant1[s : State] {
	all d : Dir | some ^parent.d & index.s implies one d.(tbc.s)
}

pred tbcInvariant2[s : State] {
	all d : Dir | some ^parent.d & index.s implies d.(tbc.s).content = {n : Name, o : Object | some x : parent.d & (index.s).*parent | o = x.(tbc.s+content) and n = x.name}
}

pred tbcPred[s : State] {
	tbcInvariant1[s]
	tbcInvariant2[s]
}

fun leaves [s : State, n : Node] : set File {
	(*parent).n & File & current.s
}

fun children[s : State, n : Node] : set Node {
	(^parent).n & current.s
}

pred descendantOf[o : Object, p : Object] {
	o in p.^children
}

fun staged[s : State] : set File {
	{f : File | f in index.s}
}

// Git knows nothing about this file
fun untracked[s : State] : set File {
	{f : File | f not in index.s and no f2 : File |	 f -> f2 in samepath and some f2.belongsTo.(HEAD[s])}
}

// modified but not staged yet
fun modified[s : State] : set File {
	{f : File |  f not in index.s and some f2 : File | f -> f2 in samepath and some f2.belongsTo.(HEAD[s]) and f2.content != f.content}	
}

pred add_invariant[s : State] {
	invariant[s]
}

pred add_state_change[s, sp : State] {
	s != sp
}

pred add_path_exists[s : State, n : Node] {
	some (n.samepath & current.s)
}

pred add_update_index[s, sp : State, n : Node] {
	index.sp = index.s - n.*parent.samepath - samepath.(*parent).(n.samepath) + leaves[s,n.samepath]
}

pred add_update_stored[s, sp : State, n : Node] {
	stored.sp = stored.s + leaves[s,n.samepath].content
}

pred add_frame_current[s, sp : State] {
	current.sp = current.s
}

pred add_frame_HEAD[s, sp : State] {
	HEAD.sp = HEAD.s
}

pred add_frame_heads[s, sp : State] {
	heads.sp = heads.s
}

pred add_frame_refs[s, sp : State] {
	refs.sp = refs.s
}

pred add_no_tbc[s : State] {
	no tbc.s
}

pred add_no_tbc_prime[sp : State] {
	no tbc.sp
}

pred add[s, sp : State, n : Node] {
	add_invariant[s]
	add_state_change[s, sp]
	add_path_exists[s, n]
	add_update_index[s, sp, n]
	add_update_stored[s, sp, n]
	add_frame_current[s, sp]
	add_frame_HEAD[s, sp]
	add_frame_heads[s, sp]
	add_frame_refs[s, sp]
	add_no_tbc[s]
	add_no_tbc_prime[sp]
}

check add_correct {
	all s,sp : State, n : Node | invariant[s] and add[s,sp,n] implies invariant[sp]
} for 7 but 2 State

pred add_invalid_path_invariant[s : State] {
	invariant[s]
}

pred add_invalid_path_no_samepath[s : State, n : Node] {
	no (n.samepath & current.s)
}

pred add_invalid_path_state_unchanged[s, sp : State] {
	sp = s
}

pred add_invalid_path[s, sp : State, n : Node] {
	add_invalid_path_invariant[s]
	add_invalid_path_no_samepath[s, n]
	add_invalid_path_state_unchanged[s, sp]
}

pred add_test_1_1 { some s: State, f: File | f.parent = Root }
pred add_test_1_2 { some s: State, f: File | f in current.s }
pred add_test_1_3 { some s, sp: State, f: File | add[s,sp,Root] }

pred state_change[s, sp: State] {
	s != sp
}

pred commit_some_index[s: State] {
	some index.s
}

pred commit_create[s, sp: State] {
	some c : Commit-stored.s | c.previous = HEAD[s]
}

pred commit_update_HEAD[s, sp: State] {
	some c : Commit-stored.s | HEAD.sp = HEAD.s
}

pred commit_update_heads[s, sp: State] {
	some c : Commit-stored.s | heads.sp = heads.s
}

pred commit_update_refs[s, sp: State] {
	some c : Commit-stored.s | refs.sp = refs.s ++ HEAD.s -> c
}

pred commit_update_tree[s, sp: State] {
	some c : Commit-stored.s | c.tree = Root.(tbc.s)
}

pred commit_update_stored[s, sp: State] {
	some c : Commit-stored.s | stored.sp = stored.s + (index.s).^parent.(tbc.s) + c
}

pred commit_frame_current[s, sp: State] {
	current.sp = current.s
}

pred commit_frame_index[s, sp: State] {
	index.sp = index.s
}

pred commit [s,sp : State, n : Node] {
	invariant[s]
	tbcPred[s]
	state_change[s, sp]
	commit_some_index[s]
	commit_create[s, sp]
	commit_update_HEAD[s, sp]
	commit_update_heads[s, sp]
	commit_update_refs[s, sp]
	commit_update_tree[s, sp]
	commit_update_stored[s, sp]
	commit_frame_current[s, sp]
	commit_frame_index[s, sp]
}

check {
	all s,sp : State, n : Node | invariant[s] and commit[s,sp, n] implies invariant[sp]
} for 3 but 2 State

pred pathInIndex [s : State, n : Node] {
	one n.samepath & index.s
}

pred noUpdatesStaged [s : State, f : File] {
	(f.samepath & index.s).content = (f.samepath & index.s).belongsTo.(HEAD[s]) or (f not in current.s)
}

pred noLocalChanges [s : State, f : File] {
	f not in current.s or (f.samepath & index.s).belongsTo.(HEAD[s]) = f.content
}

check {
	all f : File, s : State | invariant[s] and pathInIndex[s,f] and noUpdatesStaged[s,f] implies f.content = (f.samepath & index.s).content
} for 3 but 1 State

fun dirsContainingOnly [s : State, f : set File] : set Dir {
	{n : current.s - Root | n in f.*parent.samepath and (*parent.n & current.s) in f.*parent.samepath and (some d : *parent.n & current.s | f in parent.d)}
}

pred rm_update_index[s, sp : State, f : File] {
	index.sp = index.s - f.samepath
}

pred rm_update_current[s, sp : State, f : File] {
	current.sp = current.s - f.samepath - dirsContainingOnly[s,f.samepath]
}

pred rm_frame_HEAD[s, sp : State] {
	HEAD.sp = HEAD.s
}

pred rm_frame_stored[s, sp : State] {
	stored.sp = stored.s 
}

pred rm_frame_refs[s, sp : State] {
	refs.sp = refs.s
}

pred rm[s, sp : State, f : File] {
	// preconditions
	invariant[s]
	state_change[s, sp]
	pathInIndex[s,f]
	noUpdatesStaged[s,f]
	noLocalChanges[s,f]
	// postconditions
	rm_update_index[s, sp, f]
	rm_update_current[s, sp, f]
	rm_frame_HEAD[s, sp]
	rm_frame_stored[s, sp]
	rm_frame_refs[s, sp]
}

check rm_correct {
	all s,sp : State, n : Node | invariant[s] and rm[s,sp,n] implies invariant[sp]
} for 6 but 2 State

pred rm_PathNotInIndex_state_unchanged[s, sp : State] {
	sp = s
}

pred rm_PathNotInIndex[s, sp : State, f : File] {
	invariant[s]
	not pathInIndex[s,f]
	rm_PathNotInIndex_state_unchanged[s, sp]
}

pred rm_UpdatesStaged[s, sp : State, f : File] {
	invariant[s]
	pathInIndex[s,f]
	not noUpdatesStaged[s,f]
	rm_PathNotInIndex_state_unchanged[s, sp]
}

pred rm_LocalChanges[s, sp : State, f : File] {
	invariant[s]
	pathInIndex[s,f]
	noUpdatesStaged[s,f]
	not noLocalChanges[s,f]
	rm_PathNotInIndex_state_unchanged[s, sp]
}

pred equalToHEADCommit[s : State, n : Node] {
	let c = HEAD[s] | all f : leaves[s, n] | let indexObj = (f.samepath & index.s).content, workingObj = f.content, commitObj = f.belongsTo.c | workingObj = commitObj and indexObj = workingObj 
}

pred rm_rec_files_in_index[s : State, n : Node] {
	all f : leaves[s,n] | some f.samepath & index.s
}

pred rm_rec_non_empty_dir[s : State, n : Node] {
	some leaves[s, n]
}

pred rm_rec_update_index[s, sp : State, n : Node] {
	index.sp = index.s - (*parent.n).samepath
}

pred rm_rec_update_current[s, sp : State, n : Node] {
	current.sp = current.s - (leaves[s, n] + n)
}

pred rm_rec_frame_HEAD[s, sp : State] {
	HEAD.sp = HEAD.s
}

pred rm_rec_frame_heads[s, sp : State] {
	heads.sp = heads.s
}

pred rm_rec_frame_stored[s, sp : State] {
	stored.sp = stored.s 
}

pred rm_rec_frame_refs[s, sp : State] {
	refs.sp = refs.s	
}

pred rm_rec[s, sp : State, n : Node] {
	invariant[s]
	state_change[s, sp]
	rm_rec_files_in_index[s, n]
	rm_rec_non_empty_dir[s, n]
	equalToHEADCommit[s, n]
	rm_rec_update_index[s, sp, n]
	rm_rec_update_current[s, sp, n]
	rm_rec_frame_HEAD[s, sp]
	rm_rec_frame_heads[s, sp]
	rm_rec_frame_stored[s, sp]
	rm_rec_frame_refs[s, sp]
}

// true iff f1 and f2 have the same path and f2 belongs to commit c
pred commonFiles[f1, f2 : File, s : State, c : Commit] {
	f1 -> f2 in samepath and f1 in current.s and some f2.belongsTo.c
}

fun merge[f1, f2 : File] : set File {
	{ f3 : File | f1.content -> f2.content -> f3.content in merging }
}

pred commitIsReferenced[s : State, c : Commit] {
	c in Name.refs.
}

pred noFileConflicts[s : State, c : Commit] {
	no f1, f2 : File | commonFiles[f1, f2, s, c] and f1.content -> f2.content in conflict
}

pred mergeFiles[s, sp: State, c: Commit] {
	all f1, f2 : File | commonFiles[f1, f2, s, c] implies some f3 : File | f1 -> f3 in samepath and f3 in current.sp and f3 in merge[f1, f2]
}

pred updateCurrentNodes[s, sp: State, c: Commit] {
	all n : Node | n in current.sp iff (some f1, f2 : File | commonFiles[f1, f2, s, c] and n in merge[f1, f2]) or (some n.belongsTo.c and no f1 : File | commonFiles[f1, n, s, c]) or n in untracked[s]
}

pred update_HEAD[s, sp: State, c: Commit] {
	HEAD.sp = c
}

pred checkout_branch_update_refs[s, sp : State] {
	refs.sp = refs.s
}

pred checkout_branch[s, sp : State, c : Commit] {
	// Preconditions
	invariant[s]
	state_change[s, sp]
	commitIsReferenced[s, c]
	noFileConflicts[s, c]
	// no modified files 
	no modified[s]
	mergeFiles[s, sp, c]
	updateCurrentNodes[s, sp, c]
	// index remains the same
	commit_frame_index[s, sp]
	// no new objects stored
	rm_frame_stored[s, sp]
	// update the HEAD
	update_HEAD[s, sp, c]
	add_frame_heads[s, sp]
	// refs stay the same
	checkout_branch_update_refs[s, sp]
}

pred fileInSamePathAsHEAD[s: State, f: File] {
	some fp : File | f -> fp in samepath and some fp.belongsTo.(HEAD[s])
}

pred fileInSamePathAsCommit[s: State, f: File, from: lone Commit] {
	some from and some fp : File | f -> fp in samepath and some fp.belongsTo.from
}

pred updateIndexForCheckout[s, sp: State, f: File] {
	index.sp = index.s - f
}

// checkout a version of the file f from commit "from" (if provided), or from the HEAD
pred checkout_file[s, sp : State, f : File, from : lone Commit] {
	// Preconditions
	invariant[s]
	add_state_change[s, sp]
	// specified commit (or HEAD) must contain a file with the same path as f
	fileInSamePathAsHEAD[s, f] or fileInSamePathAsCommit[s, f, from]
	// Postconditions
	updateIndexForCheckout[s, sp, f]
	add_frame_HEAD[s, sp]
	add_frame_heads[s, sp]
	add_frame_refs[s, sp]
	rm_frame_stored[s, sp]
}
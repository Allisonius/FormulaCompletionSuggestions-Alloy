/**
 * Relational logic revision exercises based on a simple model of a 
 * file system trash can.
 * 
 * The model has 3 unary predicates (sets), File, Trash and
 * Protected, the latter two a sub-set of File. There is a binary 
 * predicate, link, a sub-set of File x File.
 *
 * Solve the following exercises using Alloy's relational logic, which
 * extends first-order logic with:
 *	- expression comparisons 'e1 in e2' and 'e1 = e2'
 *	- expression multiplicity tests 'some e', 'lone e', 'no e' and 'one e'
 *	- binary relational operators '.', '->', '&', '+', '-', ':>' and '<:' 
 *	- unary relational operators '~', '^' and '*'
 *	- definition of relations by comprehension
 **/

/* The set of files in the file system. */
sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash in File {}
/* The set of protected files. */
sig Protected in File {}


pred inv1o {
	no Trash
}
/* The trash is empty. */

pred inv2o {
	File in Trash
}
/* All files are deleted. */

pred inv3o {
	some Trash
}
/* Some file is deleted. */

pred inv4o {
	no Trash & Protected
}
/* Protected files cannot be deleted. */

pred inv5o {
	File = Trash + Protected
}
/* All unprotected files are deleted. */

pred inv6o {
	link in File -> lone File
}
/* A file links to at most one file. */

pred inv7o {
	no File.link & Trash
}
/* There is no deleted link. */

pred inv8o {
	no link
}
/* There are no links. */

pred inv9o {
	no link.link
}
/* A link does not link to another link. */

pred inv10o {
	all f : File | f in Trash implies f.link in Trash
}
/* If a link is deleted, so is the file it links to. */
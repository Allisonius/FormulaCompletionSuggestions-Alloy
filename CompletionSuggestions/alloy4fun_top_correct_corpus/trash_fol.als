/* The set of files in the file system. */
sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash in File {}
/* The set of protected files. */
sig Protected in File {}

/* The trash is empty. */
pred inv1 {
	all f:File|f not in Trash
}

/* All files are deleted. */
pred inv2 {
	all f:File|f in Trash
}

/* Some file is deleted. */
pred inv3 {
	some f:File|f in Trash
}

/* Protected files cannot be deleted. */
pred inv4 {
	all f:File | f in Protected => f not in Trash
}

/* All unprotected files are deleted. */
pred inv5 {
	all f:File | lone f.link
}

/* A file links to at most one file. */
pred inv6 { //same as oracle
	link in File -> lone File
}

/* There is no deleted link. */
pred inv7 {
	all f1,f2:File| f1->f2 in link implies f2 not in Trash
}

/* There are no links. */
pred inv8 { //same as oracle
	no link
}

/* A link does not link to another link. */
pred inv9 { //same as oracle
	no link.link
}

/* If a link is deleted, so is the file it links to. */
pred inv10 {
	all f1,f2:File | f1->f2 in link and f1 in Trash => f2 in Trash
}
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
pred inv1 { //same as oracle
	no Trash
}

/* All files are deleted. */
pred inv2 { //same as oracle
	File in Trash
}

/* Some file is deleted. */
pred inv3 { //same as oracle
	some Trash
}

/* Protected files cannot be deleted. */
pred inv4 { //same as oracle
	no Trash & Protected
}

/* All unprotected files are deleted. */
pred inv5 {
	File-Protected in Trash
}

/* A file links to at most one file. */
pred inv6 {
	all f:File |lone f.link
}

/* There is no deleted link. */
pred inv7 { //same as oracle
	no File.link & Trash
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
pred inv10o {
	Trash.link in Trash
}

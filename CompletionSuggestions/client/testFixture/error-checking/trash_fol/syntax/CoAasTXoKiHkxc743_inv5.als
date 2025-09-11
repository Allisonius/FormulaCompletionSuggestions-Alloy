sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash in File {}

/* The set of protected files. */
sig Protected in File {}

pred inv5{
some f:File | p:Protected | f in Trash and p not in Trash
}

/* A file links to at most one file. */


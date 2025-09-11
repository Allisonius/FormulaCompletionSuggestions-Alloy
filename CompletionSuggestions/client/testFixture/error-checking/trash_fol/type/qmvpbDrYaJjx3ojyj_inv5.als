sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash in File {}

/* The set of protected files. */
sig Protected in File {}

pred inv5{
all f : File | f not in Protected -> f in Trash
}

/* A file links to at most one file. */


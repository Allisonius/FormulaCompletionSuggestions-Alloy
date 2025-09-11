sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash in File {}

/* The set of protected files. */
sig Protected in File {}

pred inv4{
all f : File | some(f.Protected) and not f.Trash
}

/* All unprotected files are deleted.. */


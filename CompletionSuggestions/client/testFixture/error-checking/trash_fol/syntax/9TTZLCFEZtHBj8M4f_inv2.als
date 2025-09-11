sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash in File {}

/* The set of protected files. */
sig Protected in File {}

pred inv2{
all t : File | f not in Trash and
Trash' = Trash + f
File' = File
Protected' = Protected
}

/* Some file is deleted. */


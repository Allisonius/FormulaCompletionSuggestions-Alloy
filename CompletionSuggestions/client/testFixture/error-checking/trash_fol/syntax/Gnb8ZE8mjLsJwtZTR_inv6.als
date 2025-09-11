sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash in File {}

/* The set of protected files. */
sig Protected in File {}

pred inv6{
all f : File l, u : File | f -> l in link and f -> u in link implies l = u
}

/* There is no deleted link. */


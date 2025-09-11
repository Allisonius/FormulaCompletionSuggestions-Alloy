sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash in File {}

/* The set of protected files. */
sig Protected in File {}

pred inv6{
all a,b,c:File | a->b and a->c in link implies b=c
}

/* There is no deleted link. */


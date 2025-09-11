sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash in File {}

/* The set of protected files. */
sig Protected in File {}

pred inv6{
all f:File | some a:File | some b:File | f->a in link and f->b in link implies a==b
}

/* There is no deleted link. */


sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash in File {}

/* The set of protected files. */
sig Protected in File {}

pred inv6{
all f,f2,f3:File | f-> f2 and f->f3 implies f2=f3
}

/* There is no deleted link. */


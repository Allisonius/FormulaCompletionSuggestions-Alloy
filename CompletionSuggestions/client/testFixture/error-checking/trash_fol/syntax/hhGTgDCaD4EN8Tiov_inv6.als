sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash in File {}

/* The set of protected files. */
sig Protected in File {}

pred inv6{
all f : File, t,u : File  |f->t in file and f->u in file implies t=u
}

/* There is no deleted link. */


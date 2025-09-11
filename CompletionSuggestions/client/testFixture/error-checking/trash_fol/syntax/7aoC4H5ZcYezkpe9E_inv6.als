sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash in File {}

/* The set of protected files. */
sig Protected in File {}

pred inv6{
all f : File, t,u :  |w->t in working_on and w->u in working_on implies t=u
}

/* There is no deleted link. */


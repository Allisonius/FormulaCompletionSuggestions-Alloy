sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash in File {}

/* The set of protected files. */
sig Protected in File {}

pred inv6{
all x,y,z : File | x->y in File and x->z in File implies y=z
}

/* There is no deleted link. */


sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash in File {}

/* The set of protected files. */
sig Protected in File {}

pred inv6{

all disj f1,f2 : File | some (f1->f2) in link
}

/* There is no deleted link. */


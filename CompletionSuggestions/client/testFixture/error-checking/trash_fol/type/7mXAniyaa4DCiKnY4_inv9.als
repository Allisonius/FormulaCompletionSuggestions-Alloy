sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash in File {}

/* The set of protected files. */
sig Protected in File {}

pred inv9{
all x : File | all y : File | all z : File | x->y in link and y->z implies y!=z
}

/* If a link is deleted, so is the file it links to. */


sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash in File {}

/* The set of protected files. */
sig Protected in File {}

pred inv10{
all f1, f2:File | f1 -> f2 in link and f1 in Trash implies and f2 in Trash
}



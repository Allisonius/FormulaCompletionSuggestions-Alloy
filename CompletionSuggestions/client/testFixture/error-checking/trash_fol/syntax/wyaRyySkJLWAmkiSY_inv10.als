sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash in File {}

/* The set of protected files. */
sig Protected in File {}

pred inv10{
all f1,f2:File | fi->f2 in link and f2 in Trash implies f1 in Trash
}



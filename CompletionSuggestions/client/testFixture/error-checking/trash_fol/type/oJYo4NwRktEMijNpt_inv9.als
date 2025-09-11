sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash in File {}

/* The set of protected files. */
sig Protected in File {}

pred inv9{
all f1, f2:File | no (f2 in f1.link) and no (f1 in f2.link)
}

/* If a link is deleted, so is the file it links to. */


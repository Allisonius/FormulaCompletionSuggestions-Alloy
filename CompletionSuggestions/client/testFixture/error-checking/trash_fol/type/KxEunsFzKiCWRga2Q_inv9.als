sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash in File {}

/* The set of protected files. */
sig Protected in File {}

pred inv9{
all f, f1, f2 : File | f->f1 . f1->f2 not in link.link
}

/* If a link is deleted, so is the file it links to. */


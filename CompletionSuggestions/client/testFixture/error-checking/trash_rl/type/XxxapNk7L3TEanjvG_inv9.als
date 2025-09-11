sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash in File {}

/* The set of protected files. */
sig Protected in File {}

pred inv9{
all f : File |
all l : f.link |
all f2 : File |
no l.link = f2
}

/* If a link is deleted, so is the file it links to. */


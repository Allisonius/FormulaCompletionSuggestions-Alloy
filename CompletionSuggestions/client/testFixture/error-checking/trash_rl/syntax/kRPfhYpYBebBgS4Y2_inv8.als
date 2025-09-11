sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash in File {}

/* The set of protected files. */
sig Protected in File {}

pred inv8{
all f1,f2 : univ | f1->f2 in not link


}

/* A link does not link to another link. */


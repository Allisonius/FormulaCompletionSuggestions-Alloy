sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash in File {}

/* The set of protected files. */
sig Protected in File {}

pred inv6{
all f,f1,f2:File | f->f2 in link and f->f1 = f1=f2

}

/* There is no deleted link. */


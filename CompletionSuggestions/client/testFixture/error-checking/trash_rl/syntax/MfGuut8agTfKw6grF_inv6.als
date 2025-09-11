sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash in File {}

/* The set of protected files. */
sig Protected in File {}

pred inv6{

all f1,f2,f3 : File | f1->f2 in link and f1->f3 in links implies f2=f3

}

/* There is no deleted link. */


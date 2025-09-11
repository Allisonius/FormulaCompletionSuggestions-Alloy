sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash in File {}

/* The set of protected files. */
sig Protected in File {}

pred inv7{
all f:File | isLinked[f] implies f not in Trash
}

/* There are no links. */

pred isLinked(f1:File){
all f2:File | f1 -> f2 in Link
}

/* There is no deleted link. */


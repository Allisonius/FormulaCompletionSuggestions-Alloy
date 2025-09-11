sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash in File {}

/* The set of protected files. */
sig Protected in File {}

pred inv7{
all f:FIle | isLink(f) implies f not Trash
}

pred isLink[f:File]{
some g:File | f->g in link
}
/* There are no links. */


sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash in File {}

/* The set of protected files. */
sig Protected in File {}

pred inv10{
all x, y : File | isLink[x] is in Trash implies isLinked[x]
}


pred isLinked[f:File]{
some g:File | g->f in link
}

/* There are no links. */

pred isLink[f:File]{
some g:File | f->g in link
}

/* If a link is deleted, so is the file it links to. */


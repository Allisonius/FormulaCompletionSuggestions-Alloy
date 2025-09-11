sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash in File {}

/* The set of protected files. */
sig Protected in File {}

pred inv6{ all f,g : File, l,t : link | f->l->g in link and f->t->g in link implies l=t
}

/* There is no deleted link. */


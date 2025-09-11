sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash in File {}

/* The set of protected files. */
sig Protected in File {}

pred inv6{ all f,g : File | all l,t : link | f->l->g in File and f->t->g in File implies l=t
}

/* There is no deleted link. */


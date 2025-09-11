sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash in File {}

/* The set of protected files. */
sig Protected in File {}

pred inv8{
all f | not is_link[f]
}

/* A link does not link to another link. */

pred is_link[f : File]{
some g : File | f->g in link
}

/* There are no links. */


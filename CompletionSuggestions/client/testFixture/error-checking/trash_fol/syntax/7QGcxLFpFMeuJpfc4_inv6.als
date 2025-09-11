sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash in File {}

/* The set of protected files. */
sig Protected in File {}

pred inv6{
all f,g,h:File | f->g in link and f->h in link implies g=h
}

def isLink[f:File]{
some g:File | g->f in link
}
/* There is no deleted link. */


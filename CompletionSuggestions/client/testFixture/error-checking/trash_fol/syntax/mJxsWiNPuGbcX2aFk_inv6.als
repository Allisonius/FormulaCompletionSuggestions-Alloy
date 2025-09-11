sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash in File {}

/* The set of protected files. */
sig Protected in File {}

pred inv6{
all file: File | some linked: File | file->linked in links implies all otherFile: File | linked != otherFile implies file->otherFile not in links
}

/* There is no deleted link. */


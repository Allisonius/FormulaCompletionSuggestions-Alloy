sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash in File {}

/* The set of protected files. */
sig Protected in File {}

pred inv6{
all f, f', f'': File | f.link = f'' and f'.link = f'' implies f = f'

}

/* There is no deleted link. */


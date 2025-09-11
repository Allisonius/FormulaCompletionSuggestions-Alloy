sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash in File {}

/* The set of protected files. */
sig Protected in File {}

pred inv2{
all Trash :File|File in Trash & File not in Protected
}

/* Some file is deleted. */


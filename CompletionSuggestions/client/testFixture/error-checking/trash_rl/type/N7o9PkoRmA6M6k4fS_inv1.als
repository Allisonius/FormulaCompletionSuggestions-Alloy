sig File {
  	/* A file is potentially a link to other files. */
	link : set File
}
/* The set of files in the trash. */
sig Trash in File {}

/* The set of protected files. */
sig Protected in File {}

pred inv1 {
}


check inv1Ok {inv1 iff inv1o
}

pred inv1{

}


check inv1Ok {inv1 iff inv1o} for 4

pred inv1o{
no Trash
}

/* The trash is empty. */

pred inv1c {
	no Trash
}

check correct { inv1 <=> inv1c}
pred under { inv1 and !inv1c}
pred over { !inv1 and inv1c}
run over 
run under 


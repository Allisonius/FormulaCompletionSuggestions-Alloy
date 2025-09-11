sig File {
	link : set File
}
sig Trash in File {}
sig Protected in File {}

pred inv1 {
	all f : File | f not in 
}

pred inv2 {
	all f : File | f in Trash
}

pred inv3 {
	some f : File | f in Trash
}

pred inv4 {
	all f : File | f in Protected => f not in Trash
}

pred inv5 {
	all f : File | lone f.link
}

pred inv6 {
	link in File -> lone File
}

pred inv7 {
	all f1, f2 : File | f1 -> f2 in link implies f2 not in Trash
}

pred inv8 {
	no link
}

pred inv9 {
	no link.link
}

pred inv10 {
	all f1, f2 : File | f1 -> f2 in link and f1 in Trash => f2 in Trash
}

sig File {
	link : set File
}

sig Trash in File {}

sig Protected in File {}


pred inv1o {
	no Trash
}

pred inv2o {
	File in Trash
}

pred inv3o {
	some Trash
}

pred inv4o {
	no Trash & Protected
}

pred inv5o {
	File = Trash + Protected
}

pred inv6o {
	link in File -> lone File
}

pred inv7o {
	no File.link & Trash
}

pred inv8o {
	no link
}

pred inv9o {
	no link.link
}

pred inv10o {
	all f : File | f in Trash implies f.link in Trash
}
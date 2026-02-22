sig File {
	link : set File
}
sig Trash in File {}
sig Protected in File {}

pred inv1 {
	no Trash
}

pred inv2 {
	File in Trash
}

pred inv3 {
	some Trash
}

pred inv4 {
	no Trash & Protected
}

pred inv5 {
	File - Protected in Trash
}

pred inv6 {
	all f : File | lone f.
}

pred inv7 {
	no File.link & Trash
}

pred inv8 {
	no link
}

pred inv9 {
	no link.link
}

pred inv10o {
	Trash.link in Trash
}

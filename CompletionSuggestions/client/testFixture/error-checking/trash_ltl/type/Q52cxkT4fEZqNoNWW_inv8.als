var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv8{
all f1, f2 : File | f1 -> f2 in link implies eventually (f1 in Trash and f2 in Trash and f1 -> f2 in Trash)
}



var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv8{
eventually (all f1,f2:File | f1->f2 in link implies f1->f2 in Trash)
}



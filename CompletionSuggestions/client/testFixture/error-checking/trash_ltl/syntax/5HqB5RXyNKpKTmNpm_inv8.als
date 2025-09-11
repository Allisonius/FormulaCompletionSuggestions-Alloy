var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv8{
eventually some a,b:File | a->b in link after a in Trash
}



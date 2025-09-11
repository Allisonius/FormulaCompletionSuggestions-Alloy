var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv8{
all f1:File , f2:File | f1.link = f2 implies eventually f2 and f1 in Trash
}



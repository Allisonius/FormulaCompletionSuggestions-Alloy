var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv12{
some f : File | f in Trash after always f in Trash
}



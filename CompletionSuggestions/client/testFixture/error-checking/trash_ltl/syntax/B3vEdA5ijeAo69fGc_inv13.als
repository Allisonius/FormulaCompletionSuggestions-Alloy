var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv13{
all f: File | always f not in Trash before f in Trash
}



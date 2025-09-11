var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv9{
all f: File | always f not in Trash once f in Protected
}



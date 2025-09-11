var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv5{
some f: File | always no f in File since eventually f in Trash
}



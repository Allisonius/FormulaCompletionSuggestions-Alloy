var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv5{
eventually (some f:File after f not in File)
}



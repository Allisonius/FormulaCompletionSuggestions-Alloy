var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv12{
(some f:File | (eventually f in Trash) implies (always f in Trash)
}



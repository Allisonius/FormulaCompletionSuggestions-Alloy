var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv12{
since  some f:File | f not in Trash implies f in Trash'
}



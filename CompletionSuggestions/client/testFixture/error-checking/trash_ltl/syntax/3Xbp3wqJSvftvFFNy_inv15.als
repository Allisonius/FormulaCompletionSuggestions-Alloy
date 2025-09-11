var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv15{
all f:File | f not in Trash eventually f in Trash'
}



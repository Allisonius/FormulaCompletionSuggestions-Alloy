var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv12{
always some f : File | eventually some f in Trash implies f in Trash
}



var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv12{
eventually all f:File | f in Trash implies  f always in Trash
}



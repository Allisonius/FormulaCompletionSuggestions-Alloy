var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv15{
always f:File | f eventually in Trash
}



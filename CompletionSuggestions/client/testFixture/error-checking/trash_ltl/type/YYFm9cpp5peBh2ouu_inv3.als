var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv3{
always some f:File | f
}



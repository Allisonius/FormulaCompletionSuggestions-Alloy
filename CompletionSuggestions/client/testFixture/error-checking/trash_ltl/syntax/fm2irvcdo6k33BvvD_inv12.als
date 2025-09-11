var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv12{
eventually (all f:File&Trash | always f in Trash))
}



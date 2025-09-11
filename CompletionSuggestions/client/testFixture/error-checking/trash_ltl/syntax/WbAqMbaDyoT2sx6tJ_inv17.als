var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv17{
always all f:File  | since f in Trash implies f not in File'
}



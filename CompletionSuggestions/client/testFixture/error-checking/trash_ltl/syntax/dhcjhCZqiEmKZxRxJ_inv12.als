var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv12{
always all f : File | some eventually f in Trash implies f in Trash'
}



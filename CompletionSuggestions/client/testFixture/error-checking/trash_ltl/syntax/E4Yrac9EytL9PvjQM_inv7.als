var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv7{
always all f : File | some after f in Protected
}



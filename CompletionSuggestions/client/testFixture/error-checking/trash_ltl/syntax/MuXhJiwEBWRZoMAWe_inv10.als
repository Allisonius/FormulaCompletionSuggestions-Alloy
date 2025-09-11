var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv10{
always p : Protected | historically p in Proteced and always p in Protected
}



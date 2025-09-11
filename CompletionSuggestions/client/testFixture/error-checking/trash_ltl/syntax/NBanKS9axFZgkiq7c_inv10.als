var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv10{
all p: File | once p in Protected always p in Protected
}



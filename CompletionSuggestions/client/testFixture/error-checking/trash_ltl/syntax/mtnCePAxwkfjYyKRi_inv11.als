var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv11{

eventually all f:File | f not in Protected after f in Protected
}



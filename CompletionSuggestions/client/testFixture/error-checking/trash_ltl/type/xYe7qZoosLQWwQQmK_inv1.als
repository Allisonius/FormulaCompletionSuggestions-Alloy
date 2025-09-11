var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv1{
all f:File | no f in Trash and no f in Protected
}



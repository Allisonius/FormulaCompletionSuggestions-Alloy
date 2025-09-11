var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv2{
historically no File
eventually File
}



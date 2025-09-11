var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv12{

eventually (some f:File | (f in Trash) implies ((f not in Trash) releases (f in Trash))
}



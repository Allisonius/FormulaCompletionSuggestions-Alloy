var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv5{
f in File
File' = File - f
Trash' = Trash +f
}



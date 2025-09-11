var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv20{

Trash since not (Trash in Protected)
}




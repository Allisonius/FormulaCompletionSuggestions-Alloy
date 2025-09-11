var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv10{
always (Protected in after Protected and after Protected in Protected)
}



var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv2{
pred1 && (some File after no File)
}



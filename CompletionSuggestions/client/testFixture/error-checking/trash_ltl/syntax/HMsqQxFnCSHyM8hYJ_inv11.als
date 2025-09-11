var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv11{
always ( ((File - Protected) in after Protected))
}



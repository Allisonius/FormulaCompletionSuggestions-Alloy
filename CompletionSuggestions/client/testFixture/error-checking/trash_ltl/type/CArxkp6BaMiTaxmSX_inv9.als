var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv9{
all f: File | always (no f in Protected or f in Trash)
}



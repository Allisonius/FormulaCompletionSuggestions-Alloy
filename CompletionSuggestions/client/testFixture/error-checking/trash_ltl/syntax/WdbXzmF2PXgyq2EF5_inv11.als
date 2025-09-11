var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv11{
all a : File | (a not in Protected) after (a in Protected)
}



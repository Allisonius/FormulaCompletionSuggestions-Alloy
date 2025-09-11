var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv11{
always f:File | f not in Protected implies f in Protected'
}



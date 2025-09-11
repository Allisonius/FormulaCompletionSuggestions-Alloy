var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv9{
always (all f:File | f in Protected immplies f not in Trash)
}



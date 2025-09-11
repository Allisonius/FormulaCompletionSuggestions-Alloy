var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv15{
always (all f : File | f after eventually f in Trash)
}



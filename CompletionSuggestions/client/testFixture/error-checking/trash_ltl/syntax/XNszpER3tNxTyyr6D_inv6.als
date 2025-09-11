var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv6{
all f : File | f not in Protected /\ eventually f in Trash implies always f in Trash
}



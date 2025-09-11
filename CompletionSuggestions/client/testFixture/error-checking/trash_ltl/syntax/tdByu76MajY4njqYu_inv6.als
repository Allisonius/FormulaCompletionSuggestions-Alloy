var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv6{
all f : File | f in Trash eventually implies always f in Trash
}



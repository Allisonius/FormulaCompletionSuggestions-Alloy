var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv6{
all f : File | f not in trash and after f in Trash => always f in Trash
}



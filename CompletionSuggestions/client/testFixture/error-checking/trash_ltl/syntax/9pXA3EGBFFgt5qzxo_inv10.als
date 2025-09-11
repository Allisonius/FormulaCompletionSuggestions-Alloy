var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv10{
all f:File | f in protected implies always (f in protected)
}



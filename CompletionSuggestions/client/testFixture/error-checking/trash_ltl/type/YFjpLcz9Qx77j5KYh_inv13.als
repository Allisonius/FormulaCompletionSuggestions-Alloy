var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv13{
some File in Trash implies once File not in Trash
}



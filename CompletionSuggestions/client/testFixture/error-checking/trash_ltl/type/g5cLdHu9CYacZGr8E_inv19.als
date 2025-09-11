var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv19{
no Protected & Trash until Protected & Trash
}



var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv18{

all f:Protected | | f not in Protected  releases  f in Trash
}



var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv19{
always all p:Protected | f in Protected until f in Trash
}



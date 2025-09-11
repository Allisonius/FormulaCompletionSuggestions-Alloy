var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv9{
always all p:Protected | no p in Protected + Trash
}



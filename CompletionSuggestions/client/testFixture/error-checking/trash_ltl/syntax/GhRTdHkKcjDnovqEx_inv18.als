var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv18{
always f : Protected | f not in Protected until f in Trash
}



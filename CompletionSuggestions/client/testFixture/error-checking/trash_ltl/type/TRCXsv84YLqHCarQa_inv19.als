var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv19{
always (all f : Protected | f until f in Trash)
}



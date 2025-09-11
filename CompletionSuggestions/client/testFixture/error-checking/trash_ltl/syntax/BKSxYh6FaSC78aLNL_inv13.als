var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv13{
always (f : Trash | once f not in Trash)
}



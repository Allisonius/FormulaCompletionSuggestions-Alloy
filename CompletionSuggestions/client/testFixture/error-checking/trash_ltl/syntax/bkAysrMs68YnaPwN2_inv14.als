var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv14{
all f : Protected | after not in Protected since f in Trash
}



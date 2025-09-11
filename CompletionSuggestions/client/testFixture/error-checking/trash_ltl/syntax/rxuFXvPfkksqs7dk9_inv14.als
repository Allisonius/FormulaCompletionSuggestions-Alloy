var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv14{
always all f : File | f in Trash implies after f not in Protectede
}



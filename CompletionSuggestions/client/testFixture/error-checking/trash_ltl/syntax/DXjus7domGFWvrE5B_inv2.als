var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv2{
some f : File | no Trash | no Protected
}



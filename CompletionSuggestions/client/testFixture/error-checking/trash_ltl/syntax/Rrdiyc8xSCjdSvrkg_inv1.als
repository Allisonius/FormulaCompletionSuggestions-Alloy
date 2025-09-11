var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv1{
no Trash | no Protected
}



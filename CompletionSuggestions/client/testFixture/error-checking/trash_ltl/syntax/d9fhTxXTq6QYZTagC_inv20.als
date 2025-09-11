var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv20{
always (all f : Trash | f in Protected realeases f in Trash)
}




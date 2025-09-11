var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv6{
always (some f : File in Trash | f in Trash)
}



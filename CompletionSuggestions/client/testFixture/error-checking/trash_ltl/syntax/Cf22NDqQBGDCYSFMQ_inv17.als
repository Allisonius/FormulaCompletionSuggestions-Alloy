var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv17{
always all t : Trash | t not in File')
}



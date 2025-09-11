var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv16{
once Protected always Protected
}



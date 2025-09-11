var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv12{
always some File eventually Trash implies Trah = Trash'
}



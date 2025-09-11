var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv20{
always all f:File | f no it Protected triggered f in Trash
}




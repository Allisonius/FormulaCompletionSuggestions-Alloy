var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv8{
always all a,b:File | a->b in link eventually a in Trash
}



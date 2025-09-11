var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv8{
always all a,b:File | eventually a->b in link after a in Trash
}



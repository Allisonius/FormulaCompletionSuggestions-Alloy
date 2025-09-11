var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv8{

all f:File | some g:File | f->g in Link implies eventually f->g in Trash
}



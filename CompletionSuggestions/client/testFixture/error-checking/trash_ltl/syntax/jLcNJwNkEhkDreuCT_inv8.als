var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv8{
always all f:File, some f2.File| f2 in f.link implies eventually f2 in Trash
}



var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv8{
always all f: File | f.links implies eventually f.links in Trash
}



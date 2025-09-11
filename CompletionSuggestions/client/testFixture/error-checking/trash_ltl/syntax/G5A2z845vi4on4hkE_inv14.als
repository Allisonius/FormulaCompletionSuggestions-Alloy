var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv14{
alwyas(all f : (Trash & Protected) | after (f not in Protected))
}



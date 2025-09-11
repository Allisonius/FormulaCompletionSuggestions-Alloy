var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv9{
all p: Protected |eventually p implies always p not in Trash
}



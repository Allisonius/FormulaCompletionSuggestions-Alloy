var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv18{
all p: Protected | always p not in Protected implies p before in Trash
}



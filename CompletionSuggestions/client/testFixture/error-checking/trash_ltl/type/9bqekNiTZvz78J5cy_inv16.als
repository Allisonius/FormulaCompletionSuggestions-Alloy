var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv16{
always all f : File | (some (File in Protected)) implies (historically f in Protected)
}



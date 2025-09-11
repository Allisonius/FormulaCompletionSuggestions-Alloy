var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv14{

always all f:File | f in Trash and f in Protected after f in Trash and f not in Protected'

}



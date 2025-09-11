var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv14{
all f: File | eventually f in Protected and in Trash implies after f not in Protected

}



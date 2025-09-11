var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv8{
some f:File | f in Link implies eventually f in Trash

}



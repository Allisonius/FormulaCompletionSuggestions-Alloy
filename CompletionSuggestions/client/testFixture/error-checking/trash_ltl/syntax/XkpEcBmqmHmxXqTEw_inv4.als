var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv4{
some f: File | (always f not in ProtectedI ) implies eventually f in Trash

}



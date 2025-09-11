var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv17{
all f: File |always (eventually f in Trash) implies after File -f

}



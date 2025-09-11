var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv17{
all f: File | once f in Trash implies always releases f' in File

}



var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv4{
eventually File and File not in Protected implies File in Trash

}



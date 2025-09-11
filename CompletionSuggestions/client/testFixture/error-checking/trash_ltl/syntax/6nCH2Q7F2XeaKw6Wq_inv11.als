var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv11{
always all up:File-Protected implies up' in Protected


}



var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv8{

always all f,g:File | f->g in link implies eventually  f->g in Trash

}



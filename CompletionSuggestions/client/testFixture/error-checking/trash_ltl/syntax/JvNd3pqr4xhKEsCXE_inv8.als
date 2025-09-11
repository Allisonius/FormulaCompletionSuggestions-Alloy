var sig File {
	var link : lone File
}
var sig Trash in File {}

var sig Protected in File {}

pred inv8{
always (all f:File| some link^.f  implies  eventually  link^.f  in Trash)

}



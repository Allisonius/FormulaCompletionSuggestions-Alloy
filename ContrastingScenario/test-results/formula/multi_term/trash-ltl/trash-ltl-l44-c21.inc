var sig File {
	var link : lone File
}
var sig Trash in File {}
var sig Protected in File {}

// initially the trash is empty and there are no protected file
pred prop1o {
	no Trash + Protected
}

// initially there are no files, but some are immediately created
pred prop2o {
	no File and some File'
}

// there is always some file in the system
pred prop3o {
	always some File
}

// some file will eventually be sent to the trash
pred prop4o {
	eventually some Trash
}

// some file will eventually be deleted
pred prop5o {
	eventually ( some f: File | f not in File' )
}

// whenever a file is sent to the trash, it remains in there forever
pred prop6o {
	always Trash in Trash'
}

// some file will be protected
pred prop7o {
	eventually some Protected
}

// whenever a link exists, it will eventually be in the trash
pred prop8o {
	always ( all f:link.
}

// a protected file is at no time sent to the trash
pred prop9o {
	always no Protected & Trash
}

// the protected status never changes
pred prop10o {
	always Protected = Protected'
}

// every unprotected file becomes protected in the succeeding state
pred prop11o {
	always File - Protected in Protected'
}

// a file will eventually be sent to the trash and remain there indefinitely
pred prop12o {
	eventually ( some f: Trash | always f in Trash )
}

// if a file is ever in the trash, it was once outside
pred prop13o {
	always ( all f: Trash | once f not in Trash )
}

// whenever a protected file is in the trash, in the succeeding state it no longer is protected
pred prop14o {
	always ( all f: Trash & Protected | f not in Protected' )
}

// anytime a file exists, it will eventually be sent to the trash
pred prop15o {
	always ( all f: File | eventually f in Trash )
}

// if a file is protected, it has always been so
pred prop16o {
	always ( all f: Protected | historically f in Protected )
}

// when a file is sent to the trash, it is deleted in the succeeding state
pred prop17o {
	always ( no Trash & File' )
}

// protected files will only be deprotected if sent to the trash
pred prop18o {
	always all f : Protected | f in Trash releases f in Protected
}

// all protected files will be sent to the trash but remain protected until then
pred prop19o {
	always all f : Protected | f in Protected until f in Trash
}

// whenever a file is in the trash, it has been so since it was deprotected
pred prop20o {
	always ( all f:Trash | not ( f not in Trash triggered f in Protected ))
}
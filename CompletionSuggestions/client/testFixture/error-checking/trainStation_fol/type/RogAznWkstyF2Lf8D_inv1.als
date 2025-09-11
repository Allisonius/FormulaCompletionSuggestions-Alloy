sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv1{

all t : Track | some exit : Exit | some entry : Entry | t implies exit in t.succs and entry in t.succs

}


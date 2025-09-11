sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv4{

all t : Track| (some s : Track | s not in t.succs) iff (some e: Entry | s == e)

}


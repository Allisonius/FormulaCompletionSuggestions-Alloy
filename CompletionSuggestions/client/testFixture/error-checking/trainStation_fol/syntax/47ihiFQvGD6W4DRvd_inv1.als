sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv1{


some e,z:Track| e->z not in succs implies e in Exit
some e,z:Track| e->z in sucs implies e in Exit

}


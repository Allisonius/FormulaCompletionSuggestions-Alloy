sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv3{

all t:Track | t in  Exit and t not in Exist and t not in Junction implies no(t.succs)

}


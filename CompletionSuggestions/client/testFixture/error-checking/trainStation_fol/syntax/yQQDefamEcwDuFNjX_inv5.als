sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv5{

all t : Track | some y,z : Track |  t in Junction iff (t in y.succs and t in z.succs and y!=z)


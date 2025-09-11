sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv3{

all exit, entry, junction : univ | exit in Exit and entry in Entry and junction in Junction implies (entry and junction) not in exit.succs

}


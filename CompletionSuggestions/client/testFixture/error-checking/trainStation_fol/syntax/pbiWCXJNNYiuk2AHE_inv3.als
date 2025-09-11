sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv3{

all track : univ | track in Track and no track.^succs implies track in Exit and track not in track.^succ

}


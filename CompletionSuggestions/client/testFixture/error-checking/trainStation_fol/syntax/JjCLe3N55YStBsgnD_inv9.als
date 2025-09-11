sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv9{


all x,y:Tracks, s:Signal|x->y in succs and y in Junction implies x->s in signals and s not in Semaphore

}


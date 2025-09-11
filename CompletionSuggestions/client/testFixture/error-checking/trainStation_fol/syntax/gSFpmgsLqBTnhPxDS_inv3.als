sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv3{


all track : Track | no track.^succs implies track in Exit and all entry : Entry | all junction : Junction | track!=entry and junction!=exit
}


sig Track {
	succs : set Track,
	signals : set Signal
}
sig Junction, Entry, Exit in Track {}

sig Signal {}
sig Semaphore, Speed extends Signal {}

pred inv3{

all exit : Exit | all entry : Entry | all junction : Junction | entry and junction not in exit.succs

}


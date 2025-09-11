abstract sig Source {}
sig User extends Source {
    profile : set Work,
    visible : set Work
}
sig Institution extends Source {}

sig Id {}
sig Work {
    ids : some Id,
    source : one Source
}

pred inv3{
		all w: Work | all disj i1,i2: Id | all disj s1, s2: Source | profile.w and w.s1 and w.i1 implies 
}



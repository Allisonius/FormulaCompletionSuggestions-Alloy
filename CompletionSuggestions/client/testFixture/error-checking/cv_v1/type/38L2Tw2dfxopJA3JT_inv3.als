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
	all u : User | some id1, id2 : Id | some u.profile.Work.id1 and u.profile.Work.id2 implies id1 != id2
}



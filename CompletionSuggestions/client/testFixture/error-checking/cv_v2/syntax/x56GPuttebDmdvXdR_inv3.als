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
	id1,id2 : Id | all u:User | (id1.ids in u.profile and id2.ids in u.profile) implies id1!=id2
}



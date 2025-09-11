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

pred inv4{
	always (all u : User | all disj v1, v2 : u.visible | all v : (u.profile - v1 - v2)) | (no v1.ids & v2.ids) and (v1.ids + v2.ids in v.ids))
}




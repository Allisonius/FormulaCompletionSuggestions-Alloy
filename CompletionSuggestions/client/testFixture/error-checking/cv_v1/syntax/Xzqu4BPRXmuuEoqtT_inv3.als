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
	all u : User | ~allIds[u].allIds[u] in iden
}

fun allIds(u : User) : set Id {
	u.profile.Work.ids
}



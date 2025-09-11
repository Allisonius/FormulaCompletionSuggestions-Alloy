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
	all u:User, x, y:Work | (x in u.visible and y in u.visible) implies not (x.id = y.id)
}




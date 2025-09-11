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
	all u :User, v1,v2 : u.visible | no (v1.ids & v2.ids) and v1.source != v2.source) 
}




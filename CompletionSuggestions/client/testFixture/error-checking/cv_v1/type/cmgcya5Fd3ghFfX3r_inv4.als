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
    all u:User , i:Id, i1:Id | i in u.visible.ids & i1 in u.visible.ids implies i != i1
}




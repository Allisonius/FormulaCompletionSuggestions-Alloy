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
      all u: User, disj w1, w2 : u.profile | (some (w1.ids & w2.ids) && (w1.source != w2.souce) )implies not (w1 in u.visible && w2 in u.visible)
}




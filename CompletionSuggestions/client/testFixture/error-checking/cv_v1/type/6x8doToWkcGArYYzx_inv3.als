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
  all u : User, w1, w2 : Work | ((w1 in (u.profile)) & (w2 in (u.profile)) & (w1.source = w2.source)) implies (w1.ids != w2.ids)
}



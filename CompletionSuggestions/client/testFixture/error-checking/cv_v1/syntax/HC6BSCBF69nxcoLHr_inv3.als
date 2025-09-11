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
  
  all id1:Id, w1,w2:Work | (w1 in Source.profile and w2 in Source.profile and id in w1.ids) implies id1 not in w2.ids
}



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
  all u : User, w : Work {
    (w in u.profile) implies one (one w.ids.(~ids) & u.profile)
  }
}




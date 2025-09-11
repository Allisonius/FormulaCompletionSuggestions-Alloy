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
  	all u : User | all w1, w2: u.profile | (no (w1.ids <: w2.ids) && w1 in u.visible) implies not w2 u.visible
}




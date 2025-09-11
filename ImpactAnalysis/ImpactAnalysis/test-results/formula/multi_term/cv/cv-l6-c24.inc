abstract sig Source {}
sig User extends Source {
    profile : set Work,
    visible : set Work
}
sig Institution extends 

sig Id {}
sig Work {
    ids : some Id,
    source : one Source
}
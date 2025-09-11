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
	let aux = {u, User, w : Work, s : Source | u -> w in profile and w -> s in source} | all s : Source 
  		| all disj (u1, w1), (u2, w2) : aux.s | no w1.ids & w2.ids   
}



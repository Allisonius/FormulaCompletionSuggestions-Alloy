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
  		| all disj p1, p2 : aux.s | no User.p1.ids  
}



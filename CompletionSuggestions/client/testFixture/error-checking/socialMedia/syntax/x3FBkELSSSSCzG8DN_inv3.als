sig User {
	follows : set User,
	sees : set Photo,
	posts : set Photo,
	suggested : set User
}

sig Influencer extends User {}

sig Photo {
	date : one Day
}
sig Ad extends Photo {}

sig Day {}

pred inv3{


all p: Photo | all u: User | u->p in sees implies (p not in Ad and (some u1: User | u1->p in posts and u->u1 in follows)
}


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


one a: Ad | all u: User | u->a in sees
one x: User | all p: x.follows.Photo-Ad | x->p in sees
}


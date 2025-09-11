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

pred inv4{

all u : User | all a : Ad | (u->a) in posts implies (all p : Photo | u->p in posts implies p in Ad)
all u : User | u.posts in Ad implies all u.posts in Ad
}


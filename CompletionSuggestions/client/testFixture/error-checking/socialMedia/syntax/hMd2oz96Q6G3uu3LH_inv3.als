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


all u : User | all p : Photo | P in u.sees | p in Ad or some u1 : User | p in u1.post and u1 in u.follows
}


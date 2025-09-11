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

all u : User | one p : Photo | p in u.posts and p in Ad implies (all x : Photos | x in u.posts implies x in Ad)
}


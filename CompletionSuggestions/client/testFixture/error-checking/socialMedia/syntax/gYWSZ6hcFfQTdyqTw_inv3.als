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
all u : User | all p : Photo | p in user.sees && not ad.p => one u2 : User | p in p.posts | u2 in u.follows



}


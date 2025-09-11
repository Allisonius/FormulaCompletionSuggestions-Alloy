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



all u : User | all p : Photo | (p in Ad implies (all user : User | sees[user])) or (p not in Ad implies (all user : User | sees[user] and follows[user]))
}


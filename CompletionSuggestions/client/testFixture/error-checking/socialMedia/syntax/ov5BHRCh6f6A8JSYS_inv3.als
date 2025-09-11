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



all u1, u2 : User, p : Photo | not (u1 -> p in sees and u1 -> u2 in follows and p not in Add)
not some add : Ad | all u : User | u -> add not in sees

}


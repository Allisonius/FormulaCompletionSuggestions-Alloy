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


all p : Photo | all u1 : User | all u2 : User |
p in u1.sees -> (p in u2.posts and u2 in u1.follows and p not in Ad)
}


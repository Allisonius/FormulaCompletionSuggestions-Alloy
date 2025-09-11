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


all u1: User | all p: Photo | p in u1.sees implies (some u2: User | in u1.follows and p in u2.posts and p not in Ad) or p in Ad
}


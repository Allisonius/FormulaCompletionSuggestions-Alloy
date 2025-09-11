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

all u : User | all p : Photo | p in u.posts and p in photo or p in Ad and all p1 : Photo |
p1 in p.posts and p1 in Ad
}


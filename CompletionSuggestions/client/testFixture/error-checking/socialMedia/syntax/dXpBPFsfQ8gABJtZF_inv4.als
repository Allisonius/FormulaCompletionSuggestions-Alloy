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

all x: User | some p1: Photo | all p2: Photo | (p1 in x.posts and p1 in Ad) implies (p2 in x.posts and p in Ad)
}


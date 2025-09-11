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

all p:Photo | all u1:User | all p2:Photo | u1->p in posts and u1->p2 in posts | p in Ad
}


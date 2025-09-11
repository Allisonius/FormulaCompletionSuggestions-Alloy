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

all u1 : User | all p1 : Photo | all ad : Ad  | p1 == ad and p1 in u1.posts implies u1.posts == ad
}


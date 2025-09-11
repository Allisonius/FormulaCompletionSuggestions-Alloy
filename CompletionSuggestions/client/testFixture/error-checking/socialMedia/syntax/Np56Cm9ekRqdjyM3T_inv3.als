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


all u, j : User | all p : Photo | u -> p in sees implies u -> j in follows
all a : Ad | all sees.a
}


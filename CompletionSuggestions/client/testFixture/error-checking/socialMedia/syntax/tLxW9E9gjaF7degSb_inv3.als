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


all x,y: User | all p: Photo | p in x.sees | p in y.posts implies (y in x.follows or p in Ad)
}


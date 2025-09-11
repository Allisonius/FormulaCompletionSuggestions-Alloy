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



all u: User | all p: Photo-Ad | u.sees.p implies (some y: User | u->y in follows and y->p in posts)
}


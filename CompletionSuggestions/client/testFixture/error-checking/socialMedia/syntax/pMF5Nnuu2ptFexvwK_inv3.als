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



all u: User | all p: Photo-Ad | u->p in sees implies (some y: User | u->y in follows and y->x in posts)
}


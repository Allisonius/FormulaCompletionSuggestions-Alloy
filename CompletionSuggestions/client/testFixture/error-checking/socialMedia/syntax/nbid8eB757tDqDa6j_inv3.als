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


all u : User | all p : Photo | u -> p in sees implies (one a : Ad | a == p) or some f : User | u->f in follows and f->p in posts

}


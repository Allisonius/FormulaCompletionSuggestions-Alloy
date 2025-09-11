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


all u : User | all p : Photo-Ad | u->p in sees implies p in u.follows.posts
all u : User | all p : Photo | all a : Add | u->a in posts and u->p in posts implies p in Ad
}


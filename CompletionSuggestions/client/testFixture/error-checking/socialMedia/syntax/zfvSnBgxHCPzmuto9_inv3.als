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


all x : User | all p : Photo | p not in Ad and p not in posts.x implies x->p in sees
all x : User | all p : follows.x.posts not in Ad implies x->p in sees

}


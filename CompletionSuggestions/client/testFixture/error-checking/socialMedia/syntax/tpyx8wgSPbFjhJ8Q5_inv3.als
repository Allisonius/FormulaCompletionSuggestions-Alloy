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


all a : Ad | one u : Influencer | u->a in posts
all a,b : User | all p : Photos | a->b in follows implies a->p in sees

}


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


all x : User | all p : Photo | some y : User | all p in x.sees & (p in y.posts & x->y in follows) or (p in Ad)

}


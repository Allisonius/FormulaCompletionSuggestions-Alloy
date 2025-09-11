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


all x,y: User | all p: Photo | p not Ad  and x != y implies (p in x.sees && p in y.posts) implies x in y.follows


}


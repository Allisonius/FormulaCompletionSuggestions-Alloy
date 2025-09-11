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


all p : Photo - Ad | all u : User | all f : User | f in u.follows | p in f.posts | p in u.sees
all x : Ad | all y : User | x in y.sees

}


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


all x : User | all y : User | all p : Photo - Ad |((p in y.posts and p in x.sees) implies (y in x.follows)

all x : Ad | all y : User | x in y.sees

}


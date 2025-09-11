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

all x, y : User | all z : Ad | x.sees not in z and y in x.follows

all x : User | all y : Photo | x.sees in y and y is a Ad

}


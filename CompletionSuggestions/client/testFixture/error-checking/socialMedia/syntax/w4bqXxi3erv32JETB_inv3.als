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

all x, y : User | x.sees in y.posts and y in x.follows and x.sees is not Ad

all x : Ad | all y : User | sees.x in


}


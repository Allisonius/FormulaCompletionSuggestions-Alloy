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



some x : User | all y : User | y in x.follows | x.sees in y.posts

all j : User | all f : Ad | f in j.sees set -> set User

}


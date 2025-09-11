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

pred inv7{

all u : User | all u2 : User - u.follows |
u2 in u.suggested =>
(some u3 in u.follows | u2 in u3.follows)
}


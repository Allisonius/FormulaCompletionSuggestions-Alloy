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



all x : User | all y : Photo | all u : User | y not Ad && u not in x.follows implies y not in x.sees

}


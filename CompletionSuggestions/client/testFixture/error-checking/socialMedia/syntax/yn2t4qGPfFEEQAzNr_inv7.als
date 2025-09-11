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

all x: User | x not in x.sugegested all x, z: User | x!=z and z in x.suggested implies z not in x.follows and z in x.follows.follows
}


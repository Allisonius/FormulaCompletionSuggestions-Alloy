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

all u, y, z : User | (y : u.follows and z in y.follows and z not in u.follows) implies z in 			u.suggested
}


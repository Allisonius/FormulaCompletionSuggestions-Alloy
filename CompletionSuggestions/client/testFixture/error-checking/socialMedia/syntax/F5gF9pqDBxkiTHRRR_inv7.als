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

all x, y : User | x in y.suggested implies x not in y.follows and some z: User | z in x.follows and yi n z.follows
}


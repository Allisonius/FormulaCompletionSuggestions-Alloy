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




all x0,x1,x2:User | x2 in x1.follows and x1 in x0.follows and x2 not in x0.follows implies x2 in x0.suggested x0!=x2
}


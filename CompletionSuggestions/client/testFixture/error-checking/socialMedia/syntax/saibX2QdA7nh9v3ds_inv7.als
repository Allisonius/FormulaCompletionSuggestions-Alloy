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

all x0,x1,x3:User | x1 in x0.suggested and x3 in x0.folows implies x1 not in x0.follows and x0!=x1
}


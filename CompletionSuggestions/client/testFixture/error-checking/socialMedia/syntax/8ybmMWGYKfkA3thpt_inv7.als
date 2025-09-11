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

All u1,u2 : User | u2 in u1.suggested <=> (u1 != u2 and u2 not in u1.follows and u2 in u1.follows.follows)
}


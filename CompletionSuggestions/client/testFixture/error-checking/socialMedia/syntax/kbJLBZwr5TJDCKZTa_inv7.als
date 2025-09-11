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

u1, u2, u3: User | (u3 in u2.suggested and u3 in u1.follows) implies (u1 in u2.follows and u3 not in u2.follows)
}


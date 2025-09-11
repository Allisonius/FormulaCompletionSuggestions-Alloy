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

all u1,u2 : User | (u1 != i2 and u2 in u1.suggested) implies (u2 not in u1.follows and u1 != u2 and (all u3 : User | u3 in u2.follows and u1 in u3.follows))
}


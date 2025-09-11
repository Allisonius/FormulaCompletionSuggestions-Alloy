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

all u1, u2 : User | (u1 != u2 and u1->u2 in suggested) iff (some u3 : User | u1->u3 in follows and u3->u2 in follows and u1->u2 not in follows)
all a user
}


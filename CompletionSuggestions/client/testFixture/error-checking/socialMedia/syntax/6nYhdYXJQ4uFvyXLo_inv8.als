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

pred inv8{

all u: User, a: Add | u->a in sees => (some u1,u2: User | u->u1 in follows or u->u2 in suggested)
}



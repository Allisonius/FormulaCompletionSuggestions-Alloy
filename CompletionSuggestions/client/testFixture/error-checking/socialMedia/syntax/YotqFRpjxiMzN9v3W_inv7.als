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

all u1, u2, u3:User | u1->u3 in suggested iff u1->u2 in follows and u2->u3 in follows and u1->u3 not in follows
all u:User | u->u not in suggested and u2!=u1 and u1!=u3 and
}


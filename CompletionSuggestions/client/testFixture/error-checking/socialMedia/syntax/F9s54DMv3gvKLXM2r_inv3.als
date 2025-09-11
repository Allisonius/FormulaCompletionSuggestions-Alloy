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

pred inv3{


all u1: User, u2 : User, p : Photo | (p not in Ad and u1->p in sees and u2->p in posts) implies u->u2 in follows

}


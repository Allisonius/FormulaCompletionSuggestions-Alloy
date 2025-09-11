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

pred inv1{


all p : univ | p in Photo implies some u : univ | u in User and u->p in posts
some p : Photo | some u1, u2 : univ | u1->p in posts and u2-> in posts implies u1 = u2
}


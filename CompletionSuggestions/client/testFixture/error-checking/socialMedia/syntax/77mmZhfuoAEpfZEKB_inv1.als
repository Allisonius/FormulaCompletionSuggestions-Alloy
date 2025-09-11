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

all p1: Photo, p2: Photo, u1: User, u2: User | p1 = p2 and u1->p in posts and u2->p in posts implies u1 = u2
}


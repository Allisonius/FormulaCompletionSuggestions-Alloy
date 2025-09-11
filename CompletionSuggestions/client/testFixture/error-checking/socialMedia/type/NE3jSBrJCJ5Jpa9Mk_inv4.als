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

pred inv4{

all u:User,p:Photo | Ad.p and u->p in posts implies all r:Photo | u->r in posts implies r in Ad
}


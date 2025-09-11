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

all u:User, | (one p:Photo | u->p in posts and p in Ad) implies (all p1:Photo | u->p1 in posts and p1 in Ad)
}


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



all u1,u2:User, p:Photo | u1->p in posts and u2->p in posts implies u1=u2
all p:Photo | some u:user | u->p in posts
}


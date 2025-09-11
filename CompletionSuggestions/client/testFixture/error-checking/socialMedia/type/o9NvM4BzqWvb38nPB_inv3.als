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


all u1,u2 : User, p: Photo | u1.sees.p and p not in Ad implies (p in u2.posts and u2 in u1.follows)

}


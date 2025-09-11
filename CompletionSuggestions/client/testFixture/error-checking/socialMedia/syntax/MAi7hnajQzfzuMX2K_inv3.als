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


all p : Photo, u1,u2 : User | (p not in Ad and u->p in sees) implies (p in u2.posts and u2 in u1.follows)




}


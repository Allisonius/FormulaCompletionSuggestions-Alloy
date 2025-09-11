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


all u1 : User, a : Ad | u1 in sees.a implies some u2 : User | u2 in posts.a and u1 in follows.u2 + suggested.u2)
}



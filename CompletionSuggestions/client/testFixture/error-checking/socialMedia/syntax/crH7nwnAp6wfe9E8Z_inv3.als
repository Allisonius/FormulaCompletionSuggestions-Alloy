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


all p : Photos - Ad, u1,u2 : User | u1 in posts.p && u2 in sees.p => u2 in follows.u1
}


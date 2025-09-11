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


all u1 : User, i : Photo | ((no Ad.i) and u1 in sees.i) implies (some u2 : User | u1 in follows.u2 and u2 in posts.i)

}


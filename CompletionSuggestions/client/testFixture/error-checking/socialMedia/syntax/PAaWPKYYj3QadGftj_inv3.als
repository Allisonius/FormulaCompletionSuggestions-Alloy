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


all x : User , y : User , z : Photo | z not in Ad => ( z in y.posts and x in follows.y => x in sees.y ) else all x in sees.z
}


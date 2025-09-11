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

all a : Ad | all y,u : User | u in sees.a implies ((a in posts.y) and ((y in follows.u) or (y in suggested.x)))
}



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

all x : User, a : Ad | a in x.sees implies (soma y: User | a in y.posts and (y in x.follows or y in x.suggested))
}



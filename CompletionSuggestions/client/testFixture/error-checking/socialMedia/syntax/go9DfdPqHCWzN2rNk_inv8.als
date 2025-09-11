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

all u : User | all a : Ad | a in u.sees implies some u2 : User | a in u2.posts and (u1->u2 in follows or u1->u2 in suggested)
}



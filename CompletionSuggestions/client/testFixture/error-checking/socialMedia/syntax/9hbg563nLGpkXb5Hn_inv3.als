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


all p : Photo | some u : User | p in u.sees and p in ad or one u1 : User | p in u1.posts and
u1 in u.follows
}


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


all u : User, p : Photo | p in Ad => u.sees.p
all u : User, p : Photo | p not in Ad and p in u.follows.posts => u.sees.p


}


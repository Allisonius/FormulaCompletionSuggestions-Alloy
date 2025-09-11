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

pred inv4{

all u : User | one p : Photo | p in u.posts and set a : Ad | a = p implies all p1 : u.posts | p1 = Ad
}


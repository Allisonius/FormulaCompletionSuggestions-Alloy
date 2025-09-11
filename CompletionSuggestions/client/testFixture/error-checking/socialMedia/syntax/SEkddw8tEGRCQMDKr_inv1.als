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

pred inv1{

all p : Photo, u1, u2 : User | u1 -> p in posts and u2 -> p in posts => u1 == u2
}


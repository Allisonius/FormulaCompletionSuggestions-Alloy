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

all u : User | (some a : Ad, u2 : User | u -> a in sees and u2 -> a in posts) => (u -> u2 in follows or u -> u2 in suggested)
}



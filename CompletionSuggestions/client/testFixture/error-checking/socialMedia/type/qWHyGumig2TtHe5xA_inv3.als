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



all u : User, p : Photo, us : User | p in u.sees implies (p in Ad || (p in us.posts implies us in u.follows))

all u : User | u.sees in (Ad || u.follows)
}


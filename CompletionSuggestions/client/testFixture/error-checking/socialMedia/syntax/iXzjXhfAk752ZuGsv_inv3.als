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



all x, z : User, y : Photo | no Ad.y in and (z in posts.y) and (x in sees.y) implies (x in follows.z)
}


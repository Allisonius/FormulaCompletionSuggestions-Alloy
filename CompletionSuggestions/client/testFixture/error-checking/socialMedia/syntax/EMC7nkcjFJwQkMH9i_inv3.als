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


all u : User, f : Photo | (p in u.sees) implies (f not in Ad and f in u.follows.posts) or (f in Ad)

}


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




all u1 : User | some u1.posts in Add implies (all ph in Photo | u1 -> ph in posts | ph in Add)
}


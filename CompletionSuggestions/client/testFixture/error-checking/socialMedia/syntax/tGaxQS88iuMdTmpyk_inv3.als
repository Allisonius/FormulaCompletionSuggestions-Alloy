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


all u1, u2 : User, s : u.sees | (s in u1.sees and s in u2.posts and u2 in u1.follows) or (s in Ad)
}


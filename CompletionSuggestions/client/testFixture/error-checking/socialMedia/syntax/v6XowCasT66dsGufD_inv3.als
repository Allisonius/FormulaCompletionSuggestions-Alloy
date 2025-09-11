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


all u:User, p:Photo | (p in u.sees and p not in Ad) implies p in u.follows.posts and
(all p1:Photo | p1 in ad implies p1 in u.sees)
}


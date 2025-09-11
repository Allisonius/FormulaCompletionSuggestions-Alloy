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


all p,p2 : Photo | lone u , u2 : Users | p in u.sees and (( u2 in u.follows and p in u2.posts) or p in Ad
}


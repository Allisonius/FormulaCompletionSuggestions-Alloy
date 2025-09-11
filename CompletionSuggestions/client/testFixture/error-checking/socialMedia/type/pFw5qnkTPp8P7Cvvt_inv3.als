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



all x:User |all a:Ad| a not in x.follows.posts
all x:User |all a:Ad| a in x.sees in Ad
}


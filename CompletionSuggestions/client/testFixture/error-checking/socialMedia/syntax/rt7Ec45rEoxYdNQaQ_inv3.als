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


all a:Ads, u, u2: Users, p: Photos | a in u.sees | u2.posts in u1.sees => u2 in u1.follows
}


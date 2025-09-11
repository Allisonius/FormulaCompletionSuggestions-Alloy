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

all user : User | (some ad : Ad | user-> ad in posts implies user.posts in Ad) or (none ad : Ad | user-> ad in posts)
}


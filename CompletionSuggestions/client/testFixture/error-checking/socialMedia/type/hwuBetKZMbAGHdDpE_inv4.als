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

all u:User | some a:Ad | a in u.posts implies u.posts in Ad
all u:User | u is Influencer implies u.posts in Ad
}


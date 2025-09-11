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

all u:User | one a:Ad | ad in u.posts implies all p:Photo-a | p in u.posts implies p in Ad
}


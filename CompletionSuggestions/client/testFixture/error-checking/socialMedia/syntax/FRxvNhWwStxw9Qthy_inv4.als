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

all u:User | (some a:Ad | u -> a in posts) implies (all p:Photo | u-> p in posts imples p in Ad)
}


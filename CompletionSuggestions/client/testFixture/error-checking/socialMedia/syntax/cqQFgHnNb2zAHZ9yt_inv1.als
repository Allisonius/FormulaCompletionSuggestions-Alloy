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

pred inv1{

posts in User | (some a:Ad| u-> a in posts) implies (all p:Photos | u-> in posts implies p in Ad)
}


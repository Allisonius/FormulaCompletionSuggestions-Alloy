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

pred inv7{

all s:User, u:User | (u in suggested.s) = (u != s and u not in follows.s and some v:User | u in follows.v and v in follows.s)
}


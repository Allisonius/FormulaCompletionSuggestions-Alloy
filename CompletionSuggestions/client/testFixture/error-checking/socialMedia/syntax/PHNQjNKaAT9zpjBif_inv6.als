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

pred inv6{

all d:Day | u:User | p:Photo | u in Influencer implies some p:Photo | p in u.posts and d in p.date
}


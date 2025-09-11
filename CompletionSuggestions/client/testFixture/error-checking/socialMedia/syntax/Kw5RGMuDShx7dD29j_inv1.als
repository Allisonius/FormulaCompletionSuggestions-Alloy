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

all p:Photo | all u:User | all u2:User | p in u.posts and u != u2 implies none p2:Photo | p2 in u2.posts and p2 = p1
}


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

all u:User,u2:User | all p:Photo | p in u.posts and p in u2.posts implies u = u2
all u:User | all p:Photo | lone p in u.posts
}


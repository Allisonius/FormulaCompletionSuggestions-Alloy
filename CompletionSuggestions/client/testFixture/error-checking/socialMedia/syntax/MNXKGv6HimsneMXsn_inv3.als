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


all na : Photos - Ad | all u : User | na in u.follows.posts
all ad : Ad | all u : User | ad in u.sees
}


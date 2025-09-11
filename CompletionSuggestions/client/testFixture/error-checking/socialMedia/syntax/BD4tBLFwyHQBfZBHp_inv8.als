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

pred inv8{

all u : User | all ad : u.sees - Photo | all f : u.follows | all s : u.suggested | ad not in u.posts ad in f.posts or ad in s.posts and
}



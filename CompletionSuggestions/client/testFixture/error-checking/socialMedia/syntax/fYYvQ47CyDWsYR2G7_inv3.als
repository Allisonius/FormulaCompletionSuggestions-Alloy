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


all x,y : User | all a : Ad | x.sees in y.posts x.follows implies y.posts not in a
or  posts.x implies posts.x in a
}


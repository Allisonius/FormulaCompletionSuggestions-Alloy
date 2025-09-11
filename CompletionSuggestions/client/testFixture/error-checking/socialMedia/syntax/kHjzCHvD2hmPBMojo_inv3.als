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


all u:User | all p:Photos,follow:User | p in u.sees and follow in u.follows and p in follow.posts
all u:User | all ad:Ad | ad in u.sees
}


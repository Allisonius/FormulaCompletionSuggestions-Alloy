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


all x: Photo - Ad | one u:User | x in u.sees implies some p.User | p in u.follows and x in p.posts
all a: Ad | all u: User | a in u.sees
}


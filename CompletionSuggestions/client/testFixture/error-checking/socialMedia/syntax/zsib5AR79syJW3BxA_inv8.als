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

all a : Ad | all u : User | u in sees.a implies u in follows.posts.a or posts.a in u.suggested)

}



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



all u : User | some (u.sees).Ad

all u : User | all ad: Ad | u->ad in sees and (u->(posts.ad) in follows or u->(posts.ad) in suggested)
}



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

all u1 : User | all ad : Ad | ad in u1.sees | all u2 : User | ad in u2.posts
implies (u2 in u1.follows or u2 in u1.suggested)


}



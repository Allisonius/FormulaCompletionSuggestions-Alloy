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

pred inv4{


all u : User | all p : Photo | some a : Ad | a in u.posts and n in u.posts implies n in Ad

}


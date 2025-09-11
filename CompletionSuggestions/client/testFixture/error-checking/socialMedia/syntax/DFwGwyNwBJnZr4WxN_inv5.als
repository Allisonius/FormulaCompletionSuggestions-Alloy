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

pred inv5{


rall inf : Influencer | all u1 : User | inf in u1.follows and u1 not in Influencer implies (u1 not in Influencer)
}


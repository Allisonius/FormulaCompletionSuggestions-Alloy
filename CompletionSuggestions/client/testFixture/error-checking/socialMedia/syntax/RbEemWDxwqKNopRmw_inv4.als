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


all ph : Photo | all u1 : User | all ph2 : Photo | u1 -> ph in posts and u1 -> ph2 in posts | ph in Ad implies
ph2 in Ad

}


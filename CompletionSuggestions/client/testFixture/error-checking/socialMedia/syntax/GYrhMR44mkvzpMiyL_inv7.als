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

pred inv7{

all s : User.suggested | all u2: u1.follows.follows | (u2 not in u1.follows and u1!=u2) implies (u2 in u1.suggested)


}


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

all u1: User | all p: Photo | u1-> p in posts and p not in Ad implies p in Ad | u1-> p in posts and p in Ad implies p in Ad

}


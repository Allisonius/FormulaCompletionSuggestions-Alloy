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

all u1, u2 : User | all p : Photo | u1 in sees.p | u2 in posts.p | u1 follows.u2

}


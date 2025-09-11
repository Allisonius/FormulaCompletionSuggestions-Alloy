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

all u1 : User | all ph : Photo | some u1.posts in Ad implies
(ph in u1.posts and ph in Ad)

}


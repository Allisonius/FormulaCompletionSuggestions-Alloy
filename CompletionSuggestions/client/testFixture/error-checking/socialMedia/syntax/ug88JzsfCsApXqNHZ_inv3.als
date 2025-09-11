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


all p:Photo - Ad | some u1 | all u2 | (p in u1.posts and p in u2.sees) implies u1 in u2.follows

}


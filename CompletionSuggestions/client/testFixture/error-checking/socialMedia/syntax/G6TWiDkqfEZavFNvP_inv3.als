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


all p:Photo - Ad | some ua | all ub | (p in u1.posts and p in u2.sees) implies ub in ua.follows

}


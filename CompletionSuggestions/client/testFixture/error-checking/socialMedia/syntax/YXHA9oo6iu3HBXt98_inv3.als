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


all x : Photos | all y : Users | all z : Ad | (x in sees.y) implies ((x in Ad) or (some z : User | y in z.follows.posts)



}


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


all x : Ad | all y : User | x in sees.y
all x : Photos | all y : Users | all z : Ad | y in follows.y | z not in posts.y | x in sees.y


}


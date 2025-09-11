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

all p: Ad-(Photo-Ad) | some u : User | u in posts.p | all p1 in u.posts | p1 in p

}


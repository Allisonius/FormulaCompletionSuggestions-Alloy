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


all user : User | all photo : Photo | (photo in user1.posts and photo in user2.sees implies user1 in user2.follows


}


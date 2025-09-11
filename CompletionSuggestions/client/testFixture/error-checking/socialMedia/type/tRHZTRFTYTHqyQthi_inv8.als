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

pred inv8{

all user : User | all ad : Ad | ad in user.sees implies ad in (user.follows.posts or user.suggested.posts)

}



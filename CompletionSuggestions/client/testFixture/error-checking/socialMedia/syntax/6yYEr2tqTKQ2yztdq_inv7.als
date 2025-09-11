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

pred inv7{

all user : User | set suggested : user.suggested | (suggested != user and suggested not in user.follows and some following : user.follows | suggested in following.follows)
}


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

all user : User | all ad in user.sees | ad in Ad implies ((some following : user.follows | following->ad in posts) or some suggested : user.suggested | suggested->ad in posts)
}



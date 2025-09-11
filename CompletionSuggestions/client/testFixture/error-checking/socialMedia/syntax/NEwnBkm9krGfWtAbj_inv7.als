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

all x : User | u not in u.follows + u.suggested
all x : User | all u : x.follows.follows - x.follows - x| u in x.suggested
}


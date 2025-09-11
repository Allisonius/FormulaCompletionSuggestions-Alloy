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

all u : User | all u2 : u.follows.follows - u | u2 not in u.follows && u2 not u => u2 in u.suggested
}


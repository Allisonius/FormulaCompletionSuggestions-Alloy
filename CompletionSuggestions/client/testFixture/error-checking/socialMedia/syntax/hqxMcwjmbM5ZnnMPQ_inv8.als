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

all x : User | all x2 : User | all p : Photo | (p in x.sees and ((x2 in x.follows) or (x2 in x.suggested)) implies p in Ad
}



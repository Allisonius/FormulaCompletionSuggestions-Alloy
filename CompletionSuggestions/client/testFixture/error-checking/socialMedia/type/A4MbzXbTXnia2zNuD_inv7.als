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

all u : User | all s : u.suggested | all f : u.follows | s = (s in f.follows) - (s not in f) - (s != u)

}


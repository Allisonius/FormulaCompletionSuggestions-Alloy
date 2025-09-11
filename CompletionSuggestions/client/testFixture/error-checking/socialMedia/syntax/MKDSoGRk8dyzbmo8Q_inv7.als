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

all u : User | all s: u.suggested | some f: u.follows  | s != u and s in f.follows and s not in u.follows


all u : User | all s : User | s != u and s in f.follows and s not in u.follows => s in u.suggested
}


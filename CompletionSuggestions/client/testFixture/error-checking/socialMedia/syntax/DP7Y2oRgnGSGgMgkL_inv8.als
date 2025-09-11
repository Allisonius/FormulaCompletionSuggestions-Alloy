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

all u : User | all p : Photo | some v : User p in u.sees and p in Ad and v->p in posts implies v in u.suggested or u.follows

}



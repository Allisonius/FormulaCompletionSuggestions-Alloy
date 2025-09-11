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

all x : User | all y : suggested | (y not in x.follows+x) and (some z: x.follows | y in z.follows) and (y in x.suggested)


}


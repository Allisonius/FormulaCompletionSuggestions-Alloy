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

all x : User | all a: Ad | a in x.sees implies some p.User | a in p.posts and p in (x.follows + x.suggested)

}



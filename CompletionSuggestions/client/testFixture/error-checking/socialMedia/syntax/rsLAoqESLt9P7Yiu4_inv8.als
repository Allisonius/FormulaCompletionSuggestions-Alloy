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

all u: User | all p: Photo | p in u.sees implies (p in Ad or (exists x: User | x in u.follows and p in x.posts))
}



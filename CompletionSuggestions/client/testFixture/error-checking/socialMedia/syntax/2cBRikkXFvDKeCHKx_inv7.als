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


all x:User | x not in x.suggested all x, y:User | y in x.suggested iff y not in x.follows and y in x.follows.follows and x!=ys
}


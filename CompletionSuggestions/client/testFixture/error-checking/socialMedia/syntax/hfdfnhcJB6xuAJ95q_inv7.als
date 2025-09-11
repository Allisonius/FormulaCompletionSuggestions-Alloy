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


all x,x1:User | x1 in x.suggested implies x in x1.follows and (x1 not in x.follows) and x =! x1
}

